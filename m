Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbXCERBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbXCERBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXCERBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:01:51 -0500
Received: from inetc.connecttech.com ([64.7.140.42]:3254 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbXCERBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:01:50 -0500
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'FN'" <zzzz444@ml1.net>, "'Oleg Verych'" <olecom@flower.upol.cz>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: module builds need improvement / top Makefile not good enough
Date: Mon, 5 Mar 2007 12:03:24 -0500
Organization: Connect Tech Inc.
Message-ID: <07aa01c75f48$2fadc5b0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <1173102794.12256.1177759349@webmail.messagingengine.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: On Behalf Of FN
> Currently I face the following situation -- I try to build 2 drivers
> from the same Makefile
> -----------
> CWD := $(shell pwd)
> obj-m := driver1.o driver2.o
> driver1-y := d1/d2/d3/f1.o d1/d2/f2.o
> driver2-y := d1/d5/file1.o d1/d6/file2.o
CFLAGS_f1.o := -DMASK=0x123
CFLAGS_file1.o := -DMASK=0x123
CFLAGS_f2.o := -DMASK=0x456
CFLAGS_file2.o := -DMASK=0x456
> ----------
> There are 2 problems here
> 1) kbuild is forcing me to declare EXTRA_CFLAGS in global scope and 
>    I can't build my drivers properly because the MASKs are 
> incompatible. 

Fixed your makefile for you. See Documentation/kbuild/modules.

..Stu

