Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZIGVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZIGVDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZIGVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:03:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZIGVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:03:46 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20090907204645.GK18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu>
	 <20090907094953.GP18599@kernel.dk> <4AA54AA7.9080709@redhat.com>
	 <20090907184640.GG18599@kernel.dk> <20090907203627.GA17731@elte.hu>
	 <20090907204645.GK18599@kernel.dk>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 23:03:37 +0200
Message-Id: <1252357417.7959.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 22:46 +0200, Jens Axboe wrote:
> > a bug in the SMP load-balancer that can cause interactivity problems 
> > on large CPU count systems.
> 
> Worth trying on the dual core box?

I debugged the issue on a dual core :-)

It should be more pronounced on larger machines, but its present on
dual-core too.

