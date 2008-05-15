Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbYEORoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbYEORoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYEORoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:44:04 -0400
Received: from web95104.mail.in2.yahoo.com ([203.104.18.156]:36878 "HELO
	web95104.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751552AbYEORoD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:44:03 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 13:44:02 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=uo3gYfHQBHCKujenW3gtL/MtR0u/ZJ2WE8b55K658pNo/FSpm4E+XjuIbX9ugSzv12/tMVtSyiLJKcmS1gs4nHLaMZU7Rb1e+uDycuSf1ztV6XILdz1LS+oeC+OaaOc1LYIImrNG7fwGTN0e+T6LG4BhK3d0FypV3kMoOESsVuc=;
X-YMail-OSG: cbUeeOcVM1mEWc11lTG9BlVp0KLXZvL8gN4uAOEq8EVtOw08oAo8gjRO3yRHiJcB8Zf0NUfLQFa89IsZUBrfze7l31mJYBbyBAEDlKpGoPnmSEREYs8GesT3bw--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Thu, 15 May 2008 23:07:19 +0530 (IST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Kbuild Makefile output
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <339763.26248.qm@web95104.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All.
I want to collect all my object file in onedirectory and then want to create a kernel module.
For example: This my directory structure.
dir
|
--------------------------------------
|            |        |        |
dir1    dir2       dir3   dir4
This is my makefile in 'dir'.
obj-m := test.o
test-objs += \
                dir1/test1.o  \
                dir2/test2.o  \
                dir3/test3.o
all:
            make -C /usr/src/linux M=`pwd` modules

Now I want to save all output objectfile test1.o test2.o test3.o in one directory
called 'dir4' not in source directory. 'test.o' should look all this object file in 'dir4' for linking, not in the source directory and 'test.ko' should also be create in 'dir4'.
Can any one tell me, what is require changes in Kernel Makefile for the same.

Thanks
Murtuja



      Share files, take polls, and make new friends - all under one roof. Go to http://in.promos.yahoo.com/groups/
