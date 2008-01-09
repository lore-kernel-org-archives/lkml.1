Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYAIM5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYAIM5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYAIM5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:57:16 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37078 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752138AbYAIM5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:57:15 -0500
Message-ID: <399883439.31205@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 9 Jan 2008 20:57:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801090713.15655.lists@naasa.net> <399880302.13852@ustc.edu.cn> <200801091322.35133.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801091322.35133.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCaUd-0001Ko-Tt@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:22:33PM +0100, Joerg Platte wrote:
> Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> 
> Thank your for the hint with the filesystems!
> 
> > Thank you for the clue. However I cannot reproduce the bug on
> > ext2/2.6.24-rc7. Can you provide more details? Thank you.
> 
> I attached some more information. I'm using the ata_piix driver for my PATA 
> disk and cdrom drive and booted with hpet=force. Kernel 2.6.23.X has been 
                                                          ~~~~~~~~
							  not 2.6.24-rc7?

> patched with the -hrt patches to enable the hidden hpet time on the ICH4-M 
> chipset. I just rebooted the notebook and mounted /tmp again as ext2 and now 
> the iowait problem is back. Seems to be reproducible on my computer. What 
> additional information do you need?

I mounted an ext2 as tmp and find no problem. My config options are:

CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set

Fengguang

