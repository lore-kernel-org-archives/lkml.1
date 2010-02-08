Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0BHLDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:03:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0BHLDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:03:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heinz Diehl <htd@fancy-poultry.org>, Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [Bug #15196] kmem_cache_create: duplicate cache ccid2_h
Date: Mon, 8 Feb 2010 12:04:27 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera> <445R0ey9hAI.A.tNB.XozbLB@chimera> <20100208071515.GA6473@fancy-poultry.org>
In-Reply-To: <20100208071515.GA6473@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081204.28039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Heinz Diehl wrote:
> On 08.02.2010, Rafael J. Wysocki wrote: 
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15196
> > Subject		: kmem_cache_create: duplicate cache ccid2_h
> > Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> > Date		: 2010-01-30 18:33 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126487640324942&w=4
> > Handled-By	: Xiaotian Feng <xtfeng@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/77601/
> 
> Yes, it's still present in -rc7.

Hmm.  The bug is in net/dccp/ccid.c, so it looks like something for the
networking guys to merge.

Any chance to send a singed-off version of the patch do David?

Rafael
