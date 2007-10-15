Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbXJOLlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbXJOLlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbXJOLlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:41:12 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64696 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbXJOLlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:41:11 -0400
To: dada1@cosmosbay.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to find slab\'s usage?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710120701.l9C71Jx6038998@www262.sakura.ne.jp>
	<84144f020710130043v4f8e4cfbm178c88478d4b053d@mail.gmail.com>
	<200710131702.FHD09857.VSQOLFtFOJHMFO@I-love.SAKURA.ne.jp>
	<47107D7B.7020200@cosmosbay.com>
In-Reply-To: <47107D7B.7020200@cosmosbay.com>
Message-Id: <200710152041.GCJ90679.LHFVtQSJFFOOMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 15 Oct 2007 20:41:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric Dumazet wrote:
> > Yes. There is /sys/slab/ .
> > But are there any tools for browsing like /usr/bin/slabtop ?
> > Is
> >   cd /sys/slab/; for i in *; do echo -n $i " "; cat $i/slabs; done
> > the only way currently available?
> 
> Grab kernel sources, you'll find inside : Documentation/vm/slabinfo.c
> 
> gcc -o slabinfo Documentation/vm/slabinfo.c
> 
Oh, nice. Thank you.

I recompiled the kernel using the same kernel today.
However, I couldn't reproduce slab's leak today.

