Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZFNKZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZFNKZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZFNKY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:24:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZFNKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:24:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
Date: Sun, 14 Jun 2009 12:24:53 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <200906141210.17922.arnd@arndb.de> <8bd0f97a0906140317g7fcc741bwe0332dd14146c52b@mail.gmail.com>
In-Reply-To: <8bd0f97a0906140317g7fcc741bwe0332dd14146c52b@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906141224.54309.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+XcrX3Nw23ygfS5haQX9/PIZIb4FpjJdrcNu8
 q4FvZqBDRCXmFodiZYktcF5MNhU4LvnJBkKnqaqwqVeslTTNwz
 L1PvUbsSsNQd8P34XnY9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> in the Blackfin implementation, a protection violation is an
> exception, exceptions cannot be nested, there is no prioritization
> between exceptions, and a double exception is (hardware)
> unrecoverable.  so we need to catch pointers given to us from
> userspace.  if the kernel attempted to utilize that bad pointer, that
> is an exception in supervisor mode which is (software) unrecoverable
> -- our exception handler detects this and forces the system to panic.

Ok, I see. In that case it's obviously better to to include your patch 3/4.

	Arnd <><
