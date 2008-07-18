Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYGRXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYGRXwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYGRXwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:52:16 -0400
Received: from server.drzeus.cx ([85.8.24.28]:45468 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754627AbYGRXwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:52:16 -0400
Date: Sat, 19 Jul 2008 01:52:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@redhat.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix SDIO break control to now return success or an
 error
Message-ID: <20080719015213.26088d87@mjolnir.drzeus.cx>
In-Reply-To: <Pine.LNX.4.64.0807180801220.20605@anakin>
References: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
	<Pine.LNX.4.64.0807180801220.20605@anakin>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 08:02:45 +0200 (CEST)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Thu, 10 Jul 2008, David Howells wrote:
> > Fix SDIO break control to now return success or an error.
> 
> This patch is now in mainline as commit
> c43d8636971c39da993e94082fd65bfff421618e.
> 
> > This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.
> 
> But this isn't, causing
> 
> | drivers/mmc/card/sdio_uart.c:1007: warning: initialization from incompatible pointer type
> 

That's annoying. I just assumed the problem was one in Linus' or my tree
(why are people sending patches to me otherwise?). Alan, is this
something that will be in 2.6.27 or should I queue up a revert?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
