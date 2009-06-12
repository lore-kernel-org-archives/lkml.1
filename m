Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbZFLIGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbZFLIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759797AbZFLIFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:05:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZFLIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:05:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the asm-generic tree with Linus' tree
Date: Fri, 12 Jun 2009 10:05:32 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <20090612164914.e03160af.sfr@canb.auug.org.au>
In-Reply-To: <20090612164914.e03160af.sfr@canb.auug.org.au>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906121005.33490.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18eFV+jfX+1j7z/CJKA8NStkEguYx7oTljSi3B
 koAgU5ZBPCBF8hV+Ex3+Hi9X/M/tJfE3aekuqTPkOUyc9Q1yHr
 g+w8kAcpGtX93l9LSGiADZ4dz2H/7Z7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Stephen Rothwell wrote:
> Today's linux-next merge of the asm-generic tree got a conflict in
> include/asm-generic/atomic.h between commit
> 53e111a730ea8b002d57dd226098c12789993329 ("x86: Fix atomic_long_xchg() on
> 64bit") from Linus' tree and commit
> 72099ed2719fc5829bd79c6ca9d1783ed026eb37 ("asm-generic: rename atomic.h
> to atomic-long.h") from the asm-generic tree.
> 
> I applied the fix from the former patch to atomic-long.h

Hi Stephen,

I pulled Linus' tree into the asm-generic tree now and fixed the two conflicts
in the same way you did. I thought about doing a rebase on his tree instead,
but wasn't sure what works better.

	Arnd <><
