Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0CNOeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:34:13 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54077 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0CNOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pb3rj0ZfVG7VuWHDcz1bi90DcrhUZOtWDGNjheOlovpliY8H3G2r4SGTPlq3qR53jq
         ZE6ro6yvUUtNbPxr333qW2p6M1Hl4HINgKCohzJYTT2qQQHM+nll4nEEaYeFk/GP4Tfq
         hOih4Hv6Rxkaj35HTNpYwKohBFQmpxXjZXpwI=
Date: Sun, 14 Mar 2010 15:34:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf hist: Don't fprintf the callgraph
	unconditionally
Message-ID: <20100314143405.GB5312@nowhere>
References: <1268408808-13595-1-git-send-email-acme@infradead.org> <1268408808-13595-2-git-send-email-acme@infradead.org> <20100314094732.GC5158@nowhere> <20100314142152.GG6965@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314142152.GG6965@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 11:21:52AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Mar 14, 2010 at 10:47:34AM +0100, Frederic Weisbecker escreveu:
> > Hmm, so for now the callchain won't work anymore until
> > it gets properly reimplemented right?
> 
> It doesn't work in the newt interface only, it remais working if you do:
> 
> perf report | less
> perf report > output.txt
> rpm -e newt-devel ; make -C tools/perf install
> 
> :-)


Aah!


  
> > Not that much a problem as a necessary step if it really makes
> > easier for the newt integration.
> 
> This patch doesn't change the situation before it, i.e. callgraphs _in
> the newt interface_ weren't working.


Ok :-)

