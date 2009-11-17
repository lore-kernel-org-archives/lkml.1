Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZKQLV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZKQLV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZKQLV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:21:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZKQLV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:21:58 -0500
Date: Tue, 17 Nov 2009 12:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite,
 bench/mem-memcpy.c
Message-ID: <20091117112148.GA32578@elte.hu>
References: <1258086186-32317-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1258086186-32317-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091113094650.GA1364@elte.hu>
 <20091117.201925.543479723824311889.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117.201925.543479723824311889.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH 1/4] perf bench: Add new subsystem and new suite, bench/mem-memcpy.c
> Date: Fri, 13 Nov 2009 10:46:50 +0100
> 
> I've fixed mem-memcpy.c according to your comment,
> but I also have some comments.
> 
> > 
> > > +};
> > > +
> > > +struct routine routines[] = {
> > > +	{ "default",
> > > +	  memcpy,
> > > +	  "Default memcpy() provided by glibc" },
> > > +	{ NULL,
> > > +	  NULL,
> > > +	  NULL }
> > 
> > { NULL, } would be equivalent i guess.
> 
> Initializing the termination with { NULL, } causes build error.
> So I can't change this point.

ah, ok.

> 
> > > +		break;
> > > +	case BENCH_FORMAT_SIMPLE:
> > > +		if (use_clockcycle)
> > > +			printf("%lf\n",
> > > +			       (double)clock_diff / (double)length);
> > > +		else
> > > +			printf("%lf\n", bps);
> > > +		break;
> > > +	default:
> > > +		/* reaching here is something disaster */
> > > +		fprintf(stderr, "Unknown format:%d\n", bench_format);
> > 
> > could use pr_err() here i guess.
> 
> It seems that pr_err() is a wrapper for printk(),
> so I can't use pr_err() in perf.

ok.

	Ingo
