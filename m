Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYDVDQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYDVDQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYDVDP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:15:58 -0400
Received: from sandeen.net ([209.173.210.139]:27572 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbYDVDP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:15:57 -0400
Message-ID: <480D586C.1030305@sandeen.net>
Date: Mon, 21 Apr 2008 22:15:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
References: <20080419142329.GA5339@elte.hu> <20080422012819.GT108924158@sgi.com> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com>
In-Reply-To: <200804220503.16888.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
> xfs_flush_pages() does not use some of its parameters, namely:
> first, last and fiops.
> 
> This patch removes these parameters from all callsites.
> 
> Code size difference on 32-bit x86:
> 
>    text    data     bss     dec     hex filename
>  390739    2748    1708  395195   607bb linux-2.6-xfs1-TEST/fs/xfs/xfs.o
>  390567    2748    1708  395023   6070f linux-2.6-xfs2-TEST/fs/xfs/xfs.o
> 
> Compile-tested only.

FWIW this one actually does not seem to reduce stack usage anywhere.

-Eric
