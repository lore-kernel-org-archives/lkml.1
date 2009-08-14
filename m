Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZHNANe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZHNANe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbZHNANd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:13:33 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:33372 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZHNANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Aj9P0i/Z+MM0MLMdF3+ojMV2VBsZGDHZwLaMzmMBv57nLpmLiApbXrEKznlBlywvwq
         QKqxTfFAPtXZapG+81JmhBB0jO1GxsPpfK+2yAz8vWaOGXPYs5LihIFhsL2cK1hwmiwf
         ftaiEnCA5zCiDReIUO9O+B6Enlc2sARrd7k4c=
Date: Fri, 14 Aug 2009 02:13:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/2] perf tools: Add a per tracepoint counter attribute
	to get raw sample
Message-ID: <20090814001329.GB6007@nowhere>
References: <1250152039-7284-1-git-send-email-fweisbec@gmail.com> <20090813142936.GG3495@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813142936.GG3495@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:29:36AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 13, 2009 at 10:27:18AM +0200, Frederic Weisbecker escreveu:
> > Add a new flag field while opening a tracepoint perf counter:
> > 
> > 	-e tracepoint_subsystem:tracepoint_name:flags
> > 
> > This is intended to be generic although for now it only supports the
> > r[e[c[o[r[d]]]]] flag:
> > 
> > 	./perf record -e workqueue:workqueue_insertion:record
> > 	./perf record -e workqueue:workqueue_insertion:r
> > 
> > will have the same effect: enabling the raw samples record for the
> > given tracepoint counter.
> > 
> > In the future, we may want to support further flags, separated by
> > commas.
> 
> Will you at some point get those commit messages massaged into 'perf
> record --help'? :-)
> 
> - Arnaldo


Hehe, yeah, I will :-)

Oh BTW:

nobody@nowhere:~/linux/linux-2.6-tip/tools/perf/Documentation$ make
    SUBDIR ../
make[1]: « PERF-VERSION-FILE » est à jour.
    ASCIIDOC perf-annotate.html
    ASCIIDOC perf-examples.html
ERROR: perf-examples.txt: line 1: manpage document title is mandatory
WARNING: perf-examples.txt: line 8: missing [paradef-default] From an e-mail by Ingo Molnar-style entry
make: *** [perf-examples.html] Erreur 1


I've never touched an ascii doc thing. I'll soon put my hands into it.

