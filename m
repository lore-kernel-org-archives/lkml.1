Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYHYKhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYHYKhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYHYKhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:37:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbYHYKhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:37:05 -0400
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
	intensive multi-threaded task
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48B287D8.1000000@gmail.com>
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>
	 <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>
	 <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>
	 <48B287D8.1000000@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Aug 2008 12:37:02 +0200
Message-Id: <1219660622.8515.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 13:22 +0300, Török Edwin wrote:
>  
> >> Why did 2.6.24 seem to work better?
> >>     

> > That might cause some overhead on very high context switch rates.
> 
> No difference, and turning off the other features from sched_features 
> doesn't seem to help either.

OK, I'll poke a little more at is later today to see if I can spot
something

