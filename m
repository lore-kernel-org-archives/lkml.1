Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721Ab0AARVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0AARVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 12:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0AARVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 12:21:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0AARVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 12:21:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schutte <michi@uiae.at>
Subject: Re: [PATCH] fs/compat_ioctl.c: Add KD[GS]KBDIACRUC to the compatible list
Date: Fri, 1 Jan 2010 18:20:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Samuel Thibault <samuel.thibault@labri.fr>
References: <20100101135606.GA3189@graeme>
In-Reply-To: <20100101135606.GA3189@graeme>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001011820.51144.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+oMWMLUUy25xMbewNXhhQSBLzR9tdHXEmVnIi
 pSbsUDis6whqV4qG1nl+01EVMyzEF8OLLmIsSUKUlxsK85HIm6
 XcmuBzOVwFy161PCHEcpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010, Michael Schutte wrote:
> Allow handling of Unicode compose sequences by 32-bit apps on a 64-bit
> system.  The issue has been reported in <http://bugs.debian.org/540534>
> and <http://lists.altlinux.org/pipermail/kbd/2009-December/000235.html>.
> 
> A formal check of the two affected ioctls in drivers/char/vt_ioctl.c
> (introduced in 04c71976) and a test using x86 kbd 1.15.1 on a so patched
> x86_64 kernel both confirm that KD[GS]KBDIACRUC are ioctl32()
> compatible.
> 
> Signed-off-by: Michael Schutte <michi@uiae.at>

Since 2.6.32, we handle all VT specific ioctls in the vt_compat_ioctl()
function, which should fix this one implicitly. Please try to reproduce
with a recent kernel.

	Arnd
