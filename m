Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZEKPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZEKPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZEKPR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:17:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZEKPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:17:58 -0400
Subject: Re: fixed timeslice
From: Peter Zijlstra <peterz@infradead.org>
To: Jason mclaughlin <mcjason@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <8bfdd4d60905110658g186bc26el703eb1baf076616e@mail.gmail.com>
References: <8bfdd4d60905110658g186bc26el703eb1baf076616e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 11 May 2009 17:17:59 +0200
Message-Id: <1242055079.11251.282.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 09:58 -0400, Jason mclaughlin wrote:
> can't scheduling be unfair when a fixed timeslice is used as the time
> up til a process can run?
> 
> won't it work out that if a program is using the harddrive, and
> another is using cpu time and using up it's timeslices, that the
> cpu user will give less runtime opportunity to the harddrive user
> because of a wait up until timeslice to use the harddrive again?
> 
> like, doesn't the length of a timeslice change the fairness of
> scheduling opportunity for harddrive use?
> 
> can't it span the time that something is ready to take from the
> harddrive, til the time the harddrive can be used again?
> 
> can't it anyways in some cases though no matter what, because of how
> using up til a timeslice is available sometimes when something wants
> to use the harddrive again,
> and because what wants to use the harddrive can be behind what uses a
> whole timeslice?

I'm rather confused. If a task is blocked on IO its not contending for
CPU resources and is thus irrelevant to the running tasks and their
fairness.

Also, only SCHED_RR has a fixed timeslice.
