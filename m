Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZJWSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZJWSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZJWSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:31:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:33624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZJWSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:31:16 -0400
Date: Fri, 23 Oct 2009 16:31:07 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf timechart: Use pr_debug to report unknown header
	types
Message-ID: <20091023183107.GA4132@ghostprotocols.net>
References: <1256320245-8439-1-git-send-email-acme@redhat.com> <4AE1EE1B.2000500@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE1EE1B.2000500@linux.intel.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 23, 2009 at 10:55:39AM -0700, Arjan van de Ven escreveu:
> Arnaldo Carvalho de Melo wrote:
>> It was using eprintf that checked if verbose was !zero, when I converted
>> to pr_*() I made the mistake of changing it to pr_warning which caused
>> 'perf timechart' output to be way too verbose.
>>
> nack...
>
> if you EVER hit one of these you have a very very serious problem.
> hiding that is never the right thing to do. I should make this a fatal
> event instead.

OK, so I actually fixed a bug as those messages weren't being noticed if
-v wasn't used! :-)

Please take a look at latest tip to see all those messages.

- Arnaldo
