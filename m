Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZIVQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZIVQEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZIVQEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:04:14 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:1483 "EHLO
	mvpexchange120.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756751AbZIVQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:04:13 -0400
User-Agent: Microsoft-Entourage/12.0.0.071130
Date: Tue, 22 Sep 2009 09:04:15 -0700
Subject: (un)mount ramfs from C code
From: Brian McGrew <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C6DE438F.127DA%brian@visionpro.com>
Thread-Topic: (un)mount ramfs from C code
Thread-Index: Aco7nlT5ma+o8Qsi8kKmMqvlNFNoRA==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning all!

So I'm using a ramfs for temporary files, thank you whoever designed that,
it works great!

I can mkdir, mount, chmoud, readand write and then umount the thing from the
command line just fine.

What I need now is some method from within my C/C++ code to determine if the
ramfs is mounted, if not, then mount it so I can use it and unmount it when
I'm done, without making a system call.

Can this be done?  Is there any access to mount/unmount from C/C++?

-b

