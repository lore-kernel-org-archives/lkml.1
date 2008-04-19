Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYDST5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYDST5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYDST5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 15:57:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYDST5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 15:57:35 -0400
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080419184936.GA1865@elte.hu>
References: <20080419181304.GB21353@elte.hu>
	 <3d8471ca0804191147q3af7f01ei86b23b75bd0eb559@mail.gmail.com>
	 <20080419184936.GA1865@elte.hu>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 20:54:19 +0200
Message-Id: <1208631259.6452.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-19 at 20:49 +0200, Ingo Molnar wrote:
> * Guillaume Chazarain <guichaz@gmail.com> wrote:
> 
> > On 4/19/08, Ingo Molnar <mingo@elte.hu> wrote:
> > >  Guillaume Chazarain (1):
> > >       sched: fix rq->clock overflows detection with CONFIG_NO_HZ
> > 
> > This one should have been dropped (per 
> > http://lkml.org/lkml/2008/1/25/413) I don't like rq->clock relying on 
> > jiffies, and you already fixed the original manifestation of the 
> > problem in:
> 
> no, it was still needed on a testbox of Peter on nohz.

Yeah, I got a rq->clock rate of about 500ms every second. With this
patch I got the full 1000.

