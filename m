Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZFXVBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZFXVBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZFXVBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:01:41 -0400
Received: from www.tglx.de ([62.245.132.106]:39051 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZFXVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:01:40 -0400
Date: Wed, 24 Jun 2009 23:00:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
In-Reply-To: <1245876060.3038.7.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
References: <1245760130.3776.6.camel@localhost.localdomain>  <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Jaswinder Singh Rajput wrote:
> On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> 
>       248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
>       283542921  dL1-loads             (scaled from 23.28%)

Where is the point of this? dL1-loads is a completely non intuitive
artificial abbreviation.
 
Changing "L1-data-Cache-Load-Referencees" to "L1-dcache-loads" or
something similar provides a short but sufficiently self explaining
explanation of the counter.

I don't want to use a abbreviations dictionary to decode a perf
report.

Thanks,

	tglx
