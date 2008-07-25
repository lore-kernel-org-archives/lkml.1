Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYGYAF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYGYAF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYGYAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:05:15 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:42422 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYGYAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:05:13 -0400
Date: Thu, 24 Jul 2008 20:04:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdown
In-reply-to: <200807241727.41715.trenn@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

re: OSI(Windows...)

Linux will continue to claim OSI compatibility with Windows
until the day when the majority of Linux systems
have passed a Linux compatibility test rather than
a Windows compatibility test.

Re: OSI(Linux)

I've looked at O(100) DSDT's that look at OSI(Linux),
and all but serveral systems from two vendors do it by mistake.
They simply copied it from the bugged Intel reference code.

OSI(Linux) will _never_ be restored to Linux, ever.

re: the HP BIOS bug at hand.

Linux deletes the entire thermal zone when we see this.
(arguably, we could have just disabled the CRT
and kept the rest of the thermal zone).
If HP cared about testing Linux on this laptop
and had tools such that they could actually
test Linux compatiblity, it would be pretty clear
from user-space that their thermal zone was missing.

thanks,
-Len



