Return-Path: <linux-kernel-owner+w=401wt.eu-S934311AbXILPeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311AbXILPeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 11:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXILPeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 11:34:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:46545 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXILPeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 11:34:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18152.1758.872864.7897@alkaid.it.uu.se>
Date: Wed, 12 Sep 2007 17:33:50 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Robin Holt <holt@sgi.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Possible hang inside interrupt handler on sata_promise.
In-Reply-To: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
References: <20070912131904.GW14474@lnx-holt.americas.sgi.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt writes:
 > 
 > I have been experiencing hangs on a newly setup machine.  Unfortunately,
 > it appears to be hanging inside the interrupt handler as sysrq and
 > caps-lock led seem to stop working when the event occurs.  I am guessing
 > it is related to the sata_promise driver, but that is only a guess as
 > I don't get much for output.  I am running the debian unstable kernel
 > (2.6.22-1-686), but the problem also occurs with the debian stable kernel
 > (2.6.18-4-686).  I do need to boot with the acpi=off option, but am
 > not sure if that is related.  Unfortunately, I do not know much about
 > troubleshooting i386 when problems occur inside the interrupt handlers.

This is the first I've heard of a problem like this.
Since you boot with acpi=off and sysrq stops working,
I really have to suspect a mainboard interrupt problem.

 > What can I do to help troubleshoot this problem.

Unless the mainboard in question is known to be a totally
lost cause for ACPI, the first step should be to get ACPI
working.

If it's an older mainboard it might not need ACPI,
but then you should build and boot an ACPI-free kernel.
(I wouldn't trust acpi=off to be equivalent to CONFIG_ACPI=n.)

If the mainboard has an I/O-APIC then you should make sure
that the kernel can find and use it.

/Mikael
