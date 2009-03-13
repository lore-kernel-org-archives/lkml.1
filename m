Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbZCMHUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbZCMHUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZCMHTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:19:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:27074 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZCMHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wjueAtRdo6KfzlOv2qGCnorNptb/YhkoUFTwFAqKfwD7i6g6h77EhSMhBsa2NqCdN8
         zLJkbhL/Uj6mV7tRCZUeX8ANdFqcPd3ga4btzDC/nAAmdDRMkCiCfZDsgQY+Ox78LlZ5
         Iowm/u3ejxRxHkr8ck5uge3YUeoks2CvF2QvE=
MIME-Version: 1.0
Date: Fri, 13 Mar 2009 00:19:52 -0700
Message-ID: <59f1f0cb0903130019n5403ef8ct268ab187caf142a1@mail.gmail.com>
Subject: Path mapping wrapper application?
From: Aki Niimura <akineko@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linux experts,

I have one application that requires glibc 2.1.3.
I would like to use it with other Linux applications that use more
recent glibc version (such as glibc 2.3.2).
I originally thought I could workaround this problem by installing
glibc 2.1.3 library files in another directory and set LD_LIBRARY_PATH
locally.

Unfortunately it didn't work.
The trace I got using strace showed that the application didn't use
LD_LIBRARY_PATH environment variable to load the following key files.
/lib/libc.so.6
/lib/ld-linux.so.2

The paths for these libraries seems embedded in the application binary.

Now, I thought I could work around the problem if I write a simple
wrapper program to map directories.
ex.
$ wrapper_app  old_app

old_app -> /lib/libc.so.6  --> /usr/local/old_lib/libc.so.6

Before writing such application by myself, I'm wondering if there is
such linux program already available.
Also, maybe there is another way to deal with this kind of problem in Linux.
Some OS provides a way to dynamically map directories.

BTW, I'm very new to Linux but why the same libc.so.6 name is being
used for apparently not compatible libraries?

If the file name is different, for example libc.so.6.2.1, I wouldn't
have this problem.
Maybe, there is a historical reason behind this. But this glibc
version issue has caused several problems around me already.

Any suggestions will be greatly appreciated.

Best regards,
Aki Niimura
