Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZHBUE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZHBUE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZHBUE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:04:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZHBUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:04:26 -0400
Date: Sun, 2 Aug 2009 16:59:45 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ray Lee <ray-lk@madrabbit.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
	/etc/perfconfig/symbols.skip
Message-ID: <20090802195945.GD25334@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net> <2c0942db0907272058h3e1fc583w77925d0cc761c47f@mail.gmail.com> <20090802195533.GE24486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802195533.GE24486@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 02, 2009 at 09:55:33PM +0200, Ingo Molnar escreveu:
> 
> * Ray Lee <ray-lk@madrabbit.org> wrote:
> 
> > On Mon, Jul 27, 2009 at 5:10 PM, Arnaldo Carvalho de
> > Melo<acme@redhat.com> wrote:
> > > This also paves the way to add more symbol lists to be filtered out,
> > > spinlock anyone?
> > 
> > Generally, the way I've found is best to handle things like this is to either:
> > 
> > A. Have a fall-back list to use if the file isn't found, or
> > B. Start with the fall-back list of symbols to filter, then add to
> > them via /etc/... and ~/.perf/...
> > 
> > I like approaching things from the 'everything works even in a
> > broken/hasty installation' point of view, and it's paid off for me.
> > Sane defaults are a wonderfully useful thing.
> 
> Agreed.
> 
> Also, i'd not pollute /etc just yet, please lets define a good 
> default built-in list like we have now, and perhaps enable the 
> extension of it via .perf/config.
> 
> Tools should work well by default.

OK, I'll rework the patch and resubmit it.

- Arnaldo
