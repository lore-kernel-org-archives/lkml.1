Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407Ab0A3KGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0A3KGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 05:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253Ab0A3KGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 05:06:05 -0500
Received: from www.tglx.de ([62.245.132.106]:46359 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0A3KGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 05:06:04 -0500
Date: Sat, 30 Jan 2010 11:03:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steve French <smfrench@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/10] cifs: convert semaphore to mutex
In-Reply-To: <524f69651001292008g39c796a7j6f41c04b599752c7@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001301100450.3006@localhost.localdomain>
References: <524f69651001292008g39c796a7j6f41c04b599752c7@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Steve French wrote:
> > Looks good, but I'm pretty sure I've seen an equivalent patch on the
> > linux-cifs-client list before.
> >
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Jeff and I acked the cifs part of the patch series in July - not sure
> why the series didn't go in.
> 
> http://marc.info/?l=linux-kernel&m=124859649902788&w=2 looks like the
> original post

Yeah, the patch was part of a larger series which had problems here
and there. I forgot to split it out and push it seperately.

Steve, can you pick that up and push it via the cifs tree ? It's
completely stand alone and does not depend on other patches.

Thanks,

	tglx
