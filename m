Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYLLN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYLLN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYLLN3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:29:10 -0500
Received: from brick.kernel.dk ([93.163.65.50]:4016 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbYLLN3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:29:09 -0500
Date: Fri, 12 Dec 2008 14:28:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block#for-2.6.29] block: simplify and fix empty barrier
Message-ID: <20081212132849.GW23742@kernel.dk>
References: <1227846727-24980-1-git-send-email-tj@kernel.org> <4941D93A.2040405@kernel.org> <20081212063423.GF23742@kernel.dk> <49421088.1050304@kernel.org> <20081212113642.GN23742@kernel.dk> <49426676.1060606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49426676.1060606@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Fri, Dec 12 2008, Tejun Heo wrote:
> >> Jens Axboe wrote:
> >>> On Fri, Dec 12 2008, Tejun Heo wrote:
> >>>> Jens, did you have time to review this?
> >>> Sorry yes, I thought I had sent a reply on this already, weird. I
> >>> committed it last week, and it's tested fine here.
> >> Ah... thanks.  Next patchset brewing then.  :-)
> > 
> > Excellent. Are you going forward with the explicit peek/dequeue
> > interface for elv_next_request()? If not, then I'll put some time into
> > that as I think it needs doing soon. But if you are, I'll happily do
> > something else instead.
> 
> I'm actually working on that.  As you opposed to the original
> proposal, I'm changing the approach, so it would be great if we don't
> collide on the same area.

Ah nice, sounds promising! I wont step on your toes, and it'd be silly
to waste time working on the same bits, so don't worry about that.

-- 
Jens Axboe

