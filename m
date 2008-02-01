Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYBAKrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYBAKrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYBAKrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:47:36 -0500
Received: from cavuit01.kulnet.kuleuven.be ([134.58.240.43]:59815 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbYBAKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:47:35 -0500
Subject: Re: how to tell i386 from x86-64 kernel
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Rik Bobbaers <Rik.Bobbaers@icts.kuleuven.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 01 Feb 2008 11:47:29 +0100
Message-Id: <1201862849.6193.22.camel@lois>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-KULeuven-Information: Katholieke Universiteit Leuven
X-KULeuven-Scanned: Found to be clean
X-KULeuven-Envelope-From: rik.bobbaers@icts.kuleuven.be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi there,

since i'm not on the list... how about:

tail /proc/1/smaps and check the address size...
on 32 bit: ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]

on 64 bit: ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
[vdso]

there you can clearly see that your address space is double... so
there's your 32 bit vs 64 bit

as a normal user, you can do the same but with your own processes

greetings,

> Hi!
> 
> Quiz: on a booted system, how do you tell 32bit from 64bit kernel?
> 
> A1: zcat /proc/config.gz | grep CONFIG_64
> ...but config.gz is optional
> 
> A2: cat /proc/meminfo  | grep High
> ...but i386 kernel could have highmem disabled
> 
> What is _your_ answer? ;-)>

-- 
harry
aka Rik Bobbaers

K.U.Leuven - LUDIT            -=- Tel: +32 485 52 71 50
Rik.Bobbaers@icts.kuleuven.be -=- http://harry.enzoverder.be

Don't steal - the government hates competition.



Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm

