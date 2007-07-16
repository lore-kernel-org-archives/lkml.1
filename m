Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXGPH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXGPH4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGPH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:56:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:29160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXGPH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:56:11 -0400
Date: Mon, 16 Jul 2007 09:56:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Nicholas Miell <nmiell@comcast.net>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
In-Reply-To: <20070715222323.GG21668@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
 <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy>
 <20070715222323.GG21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 15 2007 23:23, Al Viro wrote:
>On Sun, Jul 15, 2007 at 02:13:21PM -0700, Nicholas Miell wrote:
>> 
>> I suspect he was asking for 
>> 
>> int getxattrat(int fd, const char *path, const char *name, void *value, 
>> 		size_t size, int flags)
>> int setxattrat(int fd, const char *path, const char *name, void *value,
>> 		size_t size, int xattrflags, int atflags)
>> 
>> rather than the ability to access xattrs as files.
>
>Just one question: what the bleeding hell for?  Not that the rest of
>..at() family made any damn sense as an interface...

fd1 = open("dir1", O_DIRECTORY):
fd2 = open("dir2", O_DIRECTORY);
system("mount -t tmpfs none dir1");
system("mount -t tmpfs none dir2");
openat(fd1, "file1", O_RDWR | O_CREAT);
openat(fd2, "file2", O_RDWR | O_CREAT);

If you have a better way to accomplish this, let me know. :)



	Jan
-- 
