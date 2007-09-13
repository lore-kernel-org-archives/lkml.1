Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbXIMOUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbXIMOUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXIMOUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:20:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48480 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbXIMOU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:20:28 -0400
Message-ID: <46E94728.9050509@garzik.org>
Date: Thu, 13 Sep 2007 10:20:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jon Ivar Rykkelid <jonry@pvv.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org>
In-Reply-To: <46E8EABF.3060409@pvv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ivar Rykkelid wrote:
> 
> Hi, I'm resending (didn't see my first attempt appear on the maillist):
> 
> 
> 
> I'm having serious disk-issues when using the on-board nvidia controller
> for my HDDs (My motherboard is a Gigabyte GA-N650SLI-DS4 with nvidia
> chipset, cpu is intel Core2Quad)
> 
> excerpt from "lspci":
> 00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
> (rev a1)
> 
> I have a normal IDE/P-ATA-disk attached to the "IDE"-controller and that
> works fine (/dev/hda)
> 
> However, any number of disks (I have tried 2 and 4) connected to the
> SATA-controller(s), will eventually fail. - See attached log (excerpt /
> anything relevant from /var/log/messages)
> 
> At first, disks were REALLY unstable, but then I disabled S.M.A.R.T.
> (both in BIOS and Linux), and I updated from the CentOS5 (equivalent of
> RHEL5) kernel (2.6.18) to the latest (at that time) official kernel from
> kernel.org:
> 
>  > uname -a
> Linux mirakel 2.6.22.5-custom_jir #2 SMP Thu Aug 30 22:06:21 CEST 2007
> i686 i686 i386 GNU/Linux
> 
> Now it will normally take a day or two before SATA crashes, so things
> are better, but still rather useless.
> 
> First error when sata_nv get into problems is always:
> "exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen"
> (as shown in the attached log-file.) - when this happens to one device,
> it'll almost instantly happen to the other disk attached to that
> controller as well. A couple of minutes (or so) later, the disk(s)
> connected to the other controller will start acting up as well (in the
> same manner). - I/O freezes, and nothing helps except a reboot...
> 
> As I run a rather large (software / md) RAID-5 disk array on this server
> (I'm doing a bit of video editing), every crash means a time-consuming
> rebuild of the disk-array...
> 
> I have given up on the sata_nv / nvidia-controllers for the time being.
> I now resort to some old PCI-connected sata-controllers which work fine
> (but slow, as they are outdated and "overloaded").
> 
> So, if anyone has a good solution / suggestion / improved driver (over
> the one supplied with the official 2.6.22.5-kernel) I am eager to give
> it a go and see if the situation can be resolved.

does adma=0 module option do anything?

	Jeff



