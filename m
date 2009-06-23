Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZFWITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZFWITH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZFWISx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:18:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFWISv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:18:51 -0400
Date: Tue, 23 Jun 2009 10:18:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter tool: builtin-stat add more events
Message-ID: <20090623081828.GB11181@elte.hu>
References: <1245703823.6167.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245703823.6167.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Added more events not it looks like on AMD box :
> 
> ./perf stat -- ls -lR  > /dev/null
> 
>  Performance counter stats for 'ls -lR':
> 
>      2507744774  cycles                                      #   2085.473 M/sec  (scaled from 13.28%)
>      1515534968  instructions                                #      0.604 IPC    (scaled from 13.28%)
>       783181797  cache-references                            #    651.304 M/sec  (scaled from 36.36%)
>        18089523  cache-misses                                #     15.043 M/sec  (scaled from 36.37%)
>       195550613  branches                                    #    162.622 M/sec  (scaled from 36.29%)
>        14623394  branch-misses                               #     12.161 M/sec  (scaled from 36.29%)
>   <not counted>  bus-cycles          
>     1203.182949  cpu-clock-msecs                            
>     1202.482671  task-clock-msecs                            #      0.990 CPUs 
>             454  page-faults                                 #      0.000 M/sec
>             454  minor-faults                                #      0.000 M/sec
>               0  major-faults                                #      0.000 M/sec
>             133  context-switches                            #      0.000 M/sec
>               1  CPU-migrations                              #      0.000 M/sec
>       744421154  L1-data-Cache-Load-Referencees              #    619.070 M/sec  (scaled from 13.20%)
>         5220656  L1-data-Cache-Load-Misses                   #      4.342 M/sec  (scaled from 13.28%)
>          438576  L1-data-Cache-Store-Referencees             #      0.365 M/sec  (scaled from 13.36%)
>   <not counted>  L1-data-Cache-Store-Misses
>         1976596  L1-data-Cache-Prefetch-Referencees          #      1.644 M/sec  (scaled from 13.44%)
>         1644021  L1-data-Cache-Prefetch-Misses               #      1.367 M/sec  (scaled from 13.52%)
>       764273224  L1-instruction-Cache-Load-Referencees       #    635.579 M/sec  (scaled from 13.53%)
>        17242789  L1-instruction-Cache-Load-Misses            #     14.339 M/sec  (scaled from 13.53%)
>   <not counted>  L1-instruction-Cache-Store-Referencees
>   <not counted>  L1-instruction-Cache-Store-Misses
>          372621  L1-instruction-Cache-Prefetch-Referencees   #      0.310 M/sec  (scaled from 13.53%)
>   <not counted>  L1-instruction-Cache-Prefetch-Misses
>        22844109  L2-Cache-Load-Referencees                   #     18.997 M/sec  (scaled from 13.53%)
>         2235733  L2-Cache-Load-Misses                        #      1.859 M/sec  (scaled from 13.53%)
>        23949920  L2-Cache-Store-Referencees                  #     19.917 M/sec  (scaled from 13.46%)
>   <not counted>  L2-Cache-Store-Misses
>   <not counted>  L2-Cache-Prefetch-Referencees
>   <not counted>  L2-Cache-Prefetch-Misses
>       732364670  Data-TLB-Cache-Load-Referencees             #    609.044 M/sec  (scaled from 13.45%)
>        16516548  Data-TLB-Cache-Load-Misses                  #     13.735 M/sec  (scaled from 13.42%)
>   <not counted>  Data-TLB-Cache-Store-Referencees
>   <not counted>  Data-TLB-Cache-Store-Misses
>   <not counted>  Data-TLB-Cache-Prefetch-Referencees
>   <not counted>  Data-TLB-Cache-Prefetch-Misses
>       766865920  Instruction-TLB-Cache-Load-Referencees      #    637.736 M/sec  (scaled from 13.42%)
>           19981  Instruction-TLB-Cache-Load-Misses           #      0.017 M/sec  (scaled from 13.40%)
>   <not counted>  Instruction-TLB-Cache-Store-Referencees
>   <not counted>  Instruction-TLB-Cache-Store-Misses
>   <not counted>  Instruction-TLB-Cache-Prefetch-Referencees
>   <not counted>  Instruction-TLB-Cache-Prefetch-Misses
>       308272002  Branch-Cache-Load-Referencees               #    256.363 M/sec  (scaled from 13.33%)
>        19226358  Branch-Cache-Load-Misses                    #     15.989 M/sec  (scaled from 13.28%)
>   <not counted>  Branch-Cache-Store-Referencees
>   <not counted>  Branch-Cache-Store-Misses
>   <not counted>  Branch-Cache-Prefetch-Referencees
>   <not counted>  Branch-Cache-Prefetch-Misses

Looks useful - but it would be nice to not touch the default 'perf 
stat' output but instead offer a few 'sets' of pre-defined events, 
which can be specified in the event list, such as:

 perf stat -e cache-events
 perf stat -e all-cache-events
 perf stat -e sw-events

Perhaps also a:

 perf stat -e all

To get output from all counters that we know about.

Regex matching on event specifiers would be useful too - there's 
already regex code in perf-report, see the --parent option.

	Ingo
