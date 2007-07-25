Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXGYIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXGYIQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXGYIQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:16:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXGYIQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:16:07 -0400
Date: Wed, 25 Jul 2007 10:15:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: david@lang.hm, Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070725081541.GA10005@elte.hu>
References: <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <Pine.LNX.4.64.0707242252250.2229@asgard.lang.hm> <46A6E80B.6030704@yahoo.com.au> <Pine.LNX.4.64.0707242316410.2229@asgard.lang.hm> <46A6FAD8.6050107@yahoo.com.au> <20070725074931.GA5125@elte.hu> <46A70299.50809@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A70299.50809@yahoo.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > And yet despite my repeated pleas, none of those people has yet 
> > > spent a bit of time with me to help analyse what is happening.
> >
> > btw., it might help to give specific, precise instructions about 
> > what people should do to help you analyze this problem.
> 
> Ray has been the first one to offer (thank you), and yes I have asked 
> him for precise details of info to collect to hopefully work out what 
> is happening with his first problem.

do you mean this paragraph:

| I guess /proc/meminfo, /proc/zoneinfo, /proc/vmstat, /proc/slabinfo 
| before and after the updatedb run with the latest kernel would be a 
| first step. top and vmstat output during the run wouldn't hurt either.

correct? Does "latest kernel" mean v2.6.22.1, or does it have to be 
v2.6.23-rc1? I guess v2.6.22.1 would be fine as this is a VM problem, 
not a scheduling problem.

the following script will gather all the above information for a 10 
seconds interval:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

Ray, please run this script before the updatedb run, once during the 
updatedb run and once after the updatedb run, and send Nick the 3 files 
it creates. (feel free to Cc: me too)

	Ingo
