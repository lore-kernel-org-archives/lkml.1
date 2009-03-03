Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZCCUg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZCCUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZCCUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:36:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:14818 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCCUgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eJE/4CdiLuFi4/KGZZeguc5eir3cWgbfde92cG/uYru/r589S2W8Qq0fWAOEvSZ/ic
         afeZa4S/q8fcbKVyqnUdfrxBZeSeNygGQIW9Oif0j2pA4p0pIh9nC0DKhq8bX9qfBQZx
         DHYWewECar6KMrnpYGHtV1gkzSyLkc1WjXHwk=
MIME-Version: 1.0
Date: Tue, 3 Mar 2009 12:36:48 -0800
Message-ID: <dd18b0c30903031236t6ed1adaen64507b0ab4be34a4@mail.gmail.com>
Subject: scripts/unifdef.c:209: error: conflicting types for 'getline'
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
I am unable to compile the kernel
(just did a git pull a few minuets ago);
here is what I see:

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
   AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
make[2]: *** [scripts/unifdef] Error 1
make[1]: *** [__headers] Error 2
make: *** [vmlinux] Error 2

The only change to .config was:

SYSFS_DEPRECATED_V2 [=y]
to
SYSFS_DEPRECATED_V2 [=n]
to see if I can make udev from:

udev: starting version 137
[    7.557317] udev: deprecated sysfs layout; update the kernel or disable
CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly

giving me this message.

also I did use a CFLAGS when compiling,
but never received this when doing so for:
2.6.29-rc5-00289-g460c133

any info would be appreciated.

regards;

-- 
Justin P. Mattock
