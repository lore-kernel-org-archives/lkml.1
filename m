Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbZCRQlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbZCRQlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZCRQlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:41:12 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:57954 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZCRQlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sEGSEBQ81431kQce8ly08yMuWYSy5yHle4N8AIkRczyu9J+jbo3BCTeUhyBY4Bc5dF
         XHzhSm+vrcuw770Zh1OOnXa5+Tt1LvbzBF+aLGlfEJ2cpa+QauGHqbP1AQPkpOuMRmto
         2qcts6Yh3W+S1CulgznT+d047u++hppf+4GCo=
Date: Wed, 18 Mar 2009 17:41:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range() (was: Re: [oops -tip]
	: x86 AMD 64)
Message-ID: <20090318164104.GB5981@nowhere>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318163531.GE21331@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 05:35:31PM +0100, Ingo Molnar wrote:
> 
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Good: f4c3c4cdb1de232
> > Bad : 1e08816af0bc345
> > 
> > Config:
> > http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> > 
> > oops:
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> > http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> > 
> > <freeze>
> 
> Steve, Frederic - the crashes above are in:
> 
> 	tracepoint_update_probe_range()
> 
> in a modular kernel apparently.
> 
> 	Ingo

Darn, ok I test this one.

