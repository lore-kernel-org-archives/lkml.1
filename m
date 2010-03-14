Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0CNOaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:30:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46607 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CNOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Z952dwqOhvizjJBM4z2vs37TK95xa7lpyzR2m3Ed3/YX8KpkkB3vN91m38rzb31k+u
         8ahzNhDw7Iufj5HEFbYOTqcIQ1+gLce7F1kiqxw6z4QaLo0gi5QyYD97aiZQE5hwpYAJ
         YUnCV1B2Tv5a30Bq4qQpt0yIJdNvafTjgZhQg=
Date: Sun, 14 Mar 2010 11:21:52 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf hist: Don't fprintf the callgraph
 unconditionally
Message-ID: <20100314142152.GG6965@ghostprotocols.net>
References: <1268408808-13595-1-git-send-email-acme@infradead.org>
 <1268408808-13595-2-git-send-email-acme@infradead.org>
 <20100314094732.GC5158@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314094732.GC5158@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 14, 2010 at 10:47:34AM +0100, Frederic Weisbecker escreveu:
> Hmm, so for now the callchain won't work anymore until
> it gets properly reimplemented right?

It doesn't work in the newt interface only, it remais working if you do:

perf report | less
perf report > output.txt
rpm -e newt-devel ; make -C tools/perf install

:-)
 
> Not that much a problem as a necessary step if it really makes
> easier for the newt integration.

This patch doesn't change the situation before it, i.e. callgraphs _in
the newt interface_ weren't working.

- Arnaldo
