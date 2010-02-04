Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0BDNEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 08:04:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab0BDNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 08:04:39 -0500
Date: Thu, 4 Feb 2010 11:04:26 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/9] perf symbols: Remove perf_session usage in symbols
 layer
Message-ID: <20100204130426.GC17391@ghostprotocols.net>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
 <20100204092613.GA32169@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204092613.GA32169@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 04, 2010 at 10:26:13AM +0100, Ingo Molnar escreveu:
> these changes reintroduce the 'perf top exits' bug:
> 
>  $ perf top -v
>  map_groups__set_modules_path_dir: cannot open /lib/modules/2.6.33-rc6-tip-00586-g398dde3-dirty/kernel dir
> 
> It's the non-existence of modules that causes a disorderly exit. I sent you 
> my config with the earlier bugreport - i think if you tried that config you'd 
> see a similar failure. I've fixed it via the commit below for now.

I tried with your config, problem was that it has:

CONFIG_MODULES=y

And lots of things marked as modules and I forgot to forgot to do a
'make modules_install' :-\

Anyway, its fixed now and I have yet another entry for 'perf test' :-)

Thanks!

- Arnaldo
