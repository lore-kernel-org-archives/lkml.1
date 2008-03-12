Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbYCLBBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbYCLBBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYCLBAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:00:53 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11964 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLBAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:00:52 -0400
Date: Tue, 11 Mar 2008 19:00:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: EXT3-fs error corruption
In-reply-to: <fa.0E7GeqGGVvu+k4VmX/Ftsj/zVh4@ifi.uio.no>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47D72B3E.2050107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0E7GeqGGVvu+k4VmX/Ftsj/zVh4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fred . wrote:
> I am running Ubuntu 8.04 "Hardy Heron" (alpha).
> 
> MSI P35 Neo
> Samsung SpinPoint T166 500 gb (7200 rpm, SATA-2, 16 mb cache)
> Samsung SpinPoint T166 250 gb (7200 rpm, SATA-2, 16 mb cache)
> 
> sda1 = Windows XP
> sdb1 = Linux
> 
> So I am listening to MP3 music in Rhythmbox 0.11.4, and surfing with
> Mozilla Firefox 3.0b3 and perhaps doing some other stuff, like maybe
> running apt-update && upgrade && clean && autoclean && autoremove or
> something in a Terminal or something.
> 
> And then my computer becomes unresponsive. The HDD LED shine all the
> time on the computer case.
> 
> Then I do Ctrl+Alt+F2 and try to login, and I type my username and
> press enter, and it waits there for a while, then it start spit some
> error messages, and wont let me in.
> 
> Like:
> EXT3-fs error (device sdb1): ext3_get_inode_loc: unable to read node
> block - inode=1599522, block=3211298
> And it can spam the console with that kind of stuff.
> 
> Then I shut down the computer (by PSU switch), restart and it borked out again.
> Shut down computer by PSU switch again, and runned HUTIL v2.10 by
> Samsung, a disk diagnostic tool that checks SMART, does disk spin up,
> spin down, read surface scan, and couple other diagnostic stuff. It
> reported no errors, and said the disk were okay.
> 
> Then I rebooted into my old Ubuntu 7.04 "Gutsy Gibbon" LiveCD and run
> some commands to fix it.
> $ sudo e2fsck -pcf /dev/sdb1
> $ sudo badblocks -sv /dev/sdb1
> 
> After that, computer worked again.
> But today (next day), my computer borked out again.
> In the same way and started spitting out error messages...
> 
> [20061.478996] journal commit I/O error
> [numbers] EXT3-fs error (device sdb1): ext3_find_entry: reading
> directory #2399041 offset 0
> 
> and stuff like:
> [numbers] EXT3-fs error (device sdb1): ext3_reserve_inode_write:
> Journal has aborted
> 
> It happened when I was using the 2.6.24-11-386 kernel.
> I am scared, I don't know if my hard disk maybe is broken. Samsung's
> HUTIL said the hard disk was okay.
> But now it happened more than once, and maybe its a bug in the kernel,
> or ext3 file system? I don't know. =/

A hardware problem would seem the most likely suspect. If it's getting 
journal I/O errors, etc. there should be error messages from whatever 
storage driver it's using though. Were those the only errors you saw?
