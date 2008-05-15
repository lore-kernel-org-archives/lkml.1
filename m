Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYEORl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYEORl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYEORlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:41:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42735 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYEORlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:41:45 -0400
Date: Thu, 15 May 2008 19:42:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Kbuild Makefile output
Message-ID: <20080515174222.GB24024@uranus.ravnborg.org>
References: <339763.26248.qm@web95104.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <339763.26248.qm@web95104.mail.in2.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 11:07:19PM +0530, murtuja bharmal wrote:
> Hello All.
> I want to collect all my object file in onedirectory and then want to create a kernel module.
> For example: This my directory structure.
> dir
> |
> --------------------------------------
> |            |        |        |
> dir1    dir2       dir3   dir4
> This is my makefile in 'dir'.
> obj-m := test.o
> test-objs += \
>                 dir1/test1.o  \
>                 dir2/test2.o  \
>                 dir3/test3.o
> all:
>             make -C /usr/src/linux M=`pwd` modules
> 
> Now I want to save all output objectfile test1.o test2.o test3.o in one directory
> called 'dir4' not in source directory. 'test.o' should look all this object file in 'dir4' for linking, not in the source directory and 'test.ko' should also be create in 'dir4'.
> Can any one tell me, what is require changes in Kernel Makefile for the same.

Do not do that...

If you really need to do so - please explain why so we can understand the rationale.
There are ~2000 modules that does not need this so what makes your maodule so special?

[Added kbuild@vger to cc as you also asked there]

	Sam
