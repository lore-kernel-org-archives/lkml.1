Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZFYEaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZFYEaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZFYE36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:29:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:33041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZFYE36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:29:58 -0400
Subject: Re: [PATCH -tip] perf_counter tools: shorten names for events
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
References: <1245760130.3776.6.camel@localhost.localdomain>
	 <20090623195656.GC8777@elte.hu>
	 <1245876060.3038.7.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0906242253270.2767@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 09:59:35 +0530
Message-Id: <1245904175.3022.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 23:00 +0200, Thomas Gleixner wrote:
> On Thu, 25 Jun 2009, Jaswinder Singh Rajput wrote:
> > On Tue, 2009-06-23 at 21:56 +0200, Ingo Molnar wrote:
> > 
> >       248064467  L1-data-Cache-Load-Referencees  (scaled from 23.27%)
> >       283542921  dL1-loads             (scaled from 23.28%)
> 
> Where is the point of this? dL1-loads is a completely non intuitive
> artificial abbreviation.
>  
> Changing "L1-data-Cache-Load-Referencees" to "L1-dcache-loads" or
> something similar provides a short but sufficiently self explaining
> explanation of the counter.
> 
> I don't want to use a abbreviations dictionary to decode a perf
> report.

Of course we need to shorten the event names, currently they are too
long and need at least 45 characters only for names, how can we show
another useful info on the screen.

Please suggest some better short names for :

  L1-data-Cache-Load-Reference                  [Hardware cache event]
  L1-data-Cache-Load-Miss                       [Hardware cache event]
  L1-data-Cache-Store-Reference                 [Hardware cache event]
  L1-data-Cache-Store-Miss                      [Hardware cache event]
  L1-data-Cache-Prefetch-Reference              [Hardware cache event]
  L1-data-Cache-Prefetch-Miss                   [Hardware cache event]
  L1-instruction-Cache-Load-Reference           [Hardware cache event]
  L1-instruction-Cache-Load-Miss                [Hardware cache event]
  L1-instruction-Cache-Store-Reference          [Hardware cache event]
  L1-instruction-Cache-Store-Miss               [Hardware cache event]
  L1-instruction-Cache-Prefetch-Reference       [Hardware cache event]
  L1-instruction-Cache-Prefetch-Miss            [Hardware cache event]
  L2-Cache-Load-Reference                       [Hardware cache event]
  L2-Cache-Load-Miss                            [Hardware cache event]
  L2-Cache-Store-Reference                      [Hardware cache event]
  L2-Cache-Store-Miss                           [Hardware cache event]
  L2-Cache-Prefetch-Reference                   [Hardware cache event]
  L2-Cache-Prefetch-Miss                        [Hardware cache event]
  Data-TLB-Cache-Load-Reference                 [Hardware cache event]
  Data-TLB-Cache-Load-Miss                      [Hardware cache event]
  Data-TLB-Cache-Store-Reference                [Hardware cache event]
  Data-TLB-Cache-Store-Miss                     [Hardware cache event]
  Data-TLB-Cache-Prefetch-Reference             [Hardware cache event]
  Data-TLB-Cache-Prefetch-Miss                  [Hardware cache event]
  Instruction-TLB-Cache-Load-Reference          [Hardware cache event]
  Instruction-TLB-Cache-Load-Miss               [Hardware cache event]
  Instruction-TLB-Cache-Store-Reference         [Hardware cache event]
  Instruction-TLB-Cache-Store-Miss              [Hardware cache event]
  Instruction-TLB-Cache-Prefetch-Reference      [Hardware cache event]
  Instruction-TLB-Cache-Prefetch-Miss           [Hardware cache event]
  Branch-Cache-Load-Reference                   [Hardware cache event]
  Branch-Cache-Load-Miss                        [Hardware cache event]
  Branch-Cache-Store-Reference                  [Hardware cache event]
  Branch-Cache-Store-Miss                       [Hardware cache event]
  Branch-Cache-Prefetch-Reference               [Hardware cache event]
  Branch-Cache-Prefetch-Miss                    [Hardware cache event]

Thanks,
--
JSR

