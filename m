Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYGVKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYGVKri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYGVKr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:47:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41512 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbYGVKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:47:26 -0400
Date: Tue, 22 Jul 2008 11:28:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jgarzik@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [build failure] hp-plus.c: (.text+0xd7c1a): undefined reference
 to `ei_close'
Message-ID: <20080722112844.338d30ff@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722072334.GA25241@elte.hu>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
	<20080721191519.GA15843@elte.hu>
	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>
	<20080722072334.GA25241@elte.hu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> find the full tested patch below. It solves the build failures i 
> triggered so far.

Yes - that matches the patch I sent Jeff on the 8th July

Subject: Re: linux-next: Tree for July 8 (ns8390)

From: Alan Cox <alan@redhat.com>

Please try this and if it sorts it fold it into the driver. This is a diff
between my tree and the linux-next tree
---

 drivers/net/hp-plus.c |    2 +-
 drivers/net/hp.c      |    2 +-
 drivers/net/ne.c      |    8 ++++----
 drivers/net/wd.c      |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

