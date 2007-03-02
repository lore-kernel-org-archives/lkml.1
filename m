Return-Path: <linux-kernel-owner+w=401wt.eu-S1423039AbXCBLsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423039AbXCBLsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423038AbXCBLsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:48:13 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:35001 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422831AbXCBLsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:48:12 -0500
Date: Fri, 2 Mar 2007 11:47:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean Delvare <khali@linux-fr.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Message-ID: <20070302114747.GB1212@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302114023.GD2163@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 12:40:23PM +0100, Pavel Machek wrote:

> Whitelist seems like a way to go :(.

The DSDT code clearly can't touch the hardware itself - hardware access 
is carried out by the kernel. If we can identify cases where ACPI reads 
and writes would touch resources claimed by other drivers, that would be 
a good starting point for working out what's going on.

Of course, this ignores the case where the DSDT just traps into SMM 
code. That one is clearly unsolvable.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
