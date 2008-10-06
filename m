Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYJFPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYJFPl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJFPlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:41:20 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:51909 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJFPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:41:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18666.12700.423808.665442@stoffel.org>
Date: Mon, 6 Oct 2008 11:41:16 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata question
In-Reply-To: <200810051127.50809.gene.heskett@gmail.com>
References: <200810051127.50809.gene.heskett@gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gene> My new ASUS M2N-SLI delux mobo has copius sata ports, at least
Gene> 8.  It is very slow to boot, like 30 seconds between the end of
Gene> the bios stuff and the "grub stage 2 loading" popping up on
Gene> screen.

Interesting.  Mine isn't slow to boot at all.  

Gene> I suspect this may be due to the equivalent of the old scsi
Gene> 'scan all luns' function, and back in my amiga days there was a
Gene> flag we could set that told the kickstart that this was the last
Gene> drive, don't check the rest.

Gene> As I only have one sata drive, and it is not part of the
Gene> operating system itself, is there a similar flag I can set in
Gene> the mbr of that drive that says this is the last drive, don't
Gene> spend time checking the rest of the addresses?

Gene> Properly applied, that should speed up a reboot by at least 30
Gene> seconds I'd think.  I have updated the bios to the newest
Gene> stable.  There is one newer, beta version.

I've only got one SATA drive and SATA DVD-RW and I don't see this
issue at all.

Where is your OS booting from?  Do you have PXE booting turned on by
any chance?  Could it be trying to network boot?  

What are your grub settings, OS, etc?

I'm running Ubuntu Intrepid Ibex 8.10 Beta, 2.6.28-rc8 (my own
compile) on an AMD 5000 AM2 CPU and 4gbs of RAM.  

John
