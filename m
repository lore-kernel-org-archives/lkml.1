Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYACSgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYACSgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYACSge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:36:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34770 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYACSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:36:33 -0500
Date: Thu, 3 Jan 2008 13:36:06 -0500
Message-Id: <200801031836.m03Ia6Cb024361@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Joe Perches <joe@perches.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 1/3] Unionfs: use printk KERN_CONT for debugging messages 
In-reply-to: Your message of "Wed, 02 Jan 2008 22:26:20 PST."
             <1199341581.6615.39.camel@localhost> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1199341581.6615.39.camel@localhost>, Joe Perches writes:
> On Thu, 2008-01-03 at 00:57 -0500, Erez Zadok wrote:

> I think printks should be single statements and
> KERN_CONT should be used as sparingly as possible.
[...]

KERN_CONT is documented as not being SMP safe, but I figured it was harmless
for just some debugging message.  Still, I like your way better.  Thanks
Joe.

> Perhaps:
> 		pr_debug("IT(%lu:%d): %s:%s:%d "
> 			 "um=%lu/%lu lm=%lu/%lu "
> 			 "uc=%lu/%lu lc=%lu/%lu\n",
> 			 inode->i_ino, bindex, file, fnx, line,
> 			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
> 			 lower_inode->i_mtime.tv_sec,
> 			 lower_inode->i_mtime.tv_nsec
> 			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
> 			 lower_inode->i_ctime.tv_sec,
> 			 lower_inode->i_ctime.tv_nsec);
[...]

Erez.
