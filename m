Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZL2AzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZL2AzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZL2AzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:55:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZL2AzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:55:03 -0500
Date: Mon, 28 Dec 2009 22:54:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/5] perf diff: Fix support for all --sort combinations
Message-ID: <20091229005429.GA17605@ghostprotocols.net>
References: <1262047716-23171-1-git-send-email-acme@infradead.org> <1262047716-23171-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262047716-23171-5-git-send-email-acme@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 28, 2009 at 10:48:36PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> When we finish creating the hist_entries we _already_ have them sorted "by
> name", in fact by what is in --sort, that is exactly how we can find the pairs
> in perf_session__match_hists as 'comm', 'dso' & 'symbol' all are strings we
> need to find the matches in the baseline session.
> 
> So only do the sort by hits followed by a resort by --sort if we need to find
> the position for shwowing the --displacement of hist entries.
> 
> Now all these modes work correctly:
> 
> Example is a simple 'perf record -f find / > /dev/null' ran twice then followed
> by the following commands:
> 
>   $ perf diff -f --sort comm
>   # Baseline  Delta      Command
>   # ........ ..........  .......
>   #
>        0.00%   +100.00%     find

Dammit, of course this one needs some more love... will work on it
tomorrow, the others, humm, _should_ be right.

Its late, I should be having some rest already, I guess, or whatever
:-)

- Arnaldo
