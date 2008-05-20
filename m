Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbYETU4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbYETU4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbYETU42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:56:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:30899 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbYETU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=mBbE25pUVgDXNo1vKrzTIMZbPR2V7Ouz8QKb7ziP9qENBmsHcJIKaxXXh+okSqbh6VtwH07H+sNt/HFOKuiB6jpuQGktGeYpgknZ4Ox8vyLUdA/hHhv6wK5ZPX7rkOD4aCQ+tR5p5ybZD5Msr0cs+ahXsl2US9SclFtsi2Ch6oM=
Message-ID: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
Date: Tue, 20 May 2008 22:56:12 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Compile warning rtmutex code on 2.6.24.7-rt8 (CC:LKML added)
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f8c2c3749bc3b305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

 Do you recognise these warnings? I do not know (yet) if these are ARM
 specific...

  CC      kernel/rtmutex.o
 kernel/rtmutex.c: In function 'rt_write_fastlock':
 kernel/rtmutex.c:1582: warning: initialization makes pointer from
 integer without a cast
 kernel/rtmutex.c: In function 'rt_write_fasttrylock':
 kernel/rtmutex.c:1622: warning: initialization makes pointer from
 integer without a cast

 If so, do you have a fix for it?

 Regards,


 Remy
