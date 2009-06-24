Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZFXM5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZFXM5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZFXM5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:57:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:58760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFXM5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:57:34 -0400
Subject: Re: [PATCH] perf stat: fix hardcoded nr_counter
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090624085812.GD18713@elte.hu>
References: <1245810296.3434.3.camel@ht.satnam>
	 <20090624085812.GD18713@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 18:26:57 +0530
Message-Id: <1245848217.2681.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 10:58 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > nr_counter should be based on number of default_attrs entries.
> 
> The problem is, this will cause a _lot_ of counters to be used by 
> default, overloading the PMU quite significantly and reducing 
> precision. The number of hw counters is chosen intentionally the way 
> it is now, so that on common hardware there's no over-commit.
> 
> As i suggested before, your change does make sense if introduced as 
> extended event specifications to 'perf stat':
> 
>  -e all
>  -e all-sw-counters
>  -e all-hw-counters
> 
> with regex wildcard support too.
> 

Ok I will support it now.

> Instead, you chose to ignore my feedback and wasted my time by 
> re-sending the same broken patch. If you do such things i'll have to 
> start ignoring you - it is very ineffective for me to repeat every 
> argument and suggestion two or more times and no other contributor 
> does this ...
> 

oops, I am sorry my AMD box was not able to boot because of the
regression the only machine which supports performance counter. I was
doing git-bisect on AMD box in the mean time I prepare this patch on old
Intel box.

> > Remove dead code and some code alignment.
> 
> Could you please send this separately?
> 

Send [PATCH -tip] perf stat: remove dead code

Thanks,
--
JSR

