Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZLOM4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZLOM4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZLOM4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:56:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZLOM4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:56:11 -0500
Date: Tue, 15 Dec 2009 10:55:42 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
Subject: Re: [tip:perf/diff] perf diff: Introduce tool to show performance
	difference
Message-ID: <20091215125542.GF21796@ghostprotocols.net>
References: <1260828571-3613-3-git-send-email-acme@infradead.org> <tip-86a9eee047ba09a714c3b8e27c9df2bbf715393a@git.kernel.org> <20091215095214.GA749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215095214.GA749@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 15, 2009 at 10:52:14AM +0100, Ingo Molnar escreveu:
> 
> 'perf diff' looks to be very useful!
> 
> I think we want to improve the default output some more:
> 
> For example there should be column names like for perf report:
> 
> # Overhead    Command                 Shared Object  Symbol
> # ........  .........  ............................  ......
> #
>     13.87%  hackbench  [kernel]                      [k] _raw_spin_lock
>      5.60%  hackbench  [kernel]                      [k] copy_user_generic_string
>      5.23%  hackbench  [kernel]                      [k] __cache_free

Ok, most suggestions boil down to move more code from builtin-report.c
to session.c and use in builtin-diff.c. Surgery beginning.

- Arnaldo
