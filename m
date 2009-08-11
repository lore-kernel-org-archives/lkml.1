Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZHKMZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZHKMZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZHKMZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:25:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:21130 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZHKMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCn0QmkfrGy2mrqgjbD2+C2jPs39/ezK7YBL4cWW4vm6bwdLEiIsd5kpvFM8MqqMTo
         fNSMqLrPqhscVuenH7khVEKDQI5yW4eNvuYWuOHDcuESSkqpThp4cHVE3thnim8PUDsl
         JBkUGjQCtmUkJDEvje4dRyTdjolrObgU8jeew=
Date: Tue, 11 Aug 2009 14:25:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 10/12] add perf counter support
Message-ID: <20090811122507.GG4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <b9d3c5f9d0ff2fb71993530873807443a0c7eb64.1249932670.git.jbaron@redhat.com> <20090811121227.GF4938@nowhere> <20090811121711.GA31549@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811121711.GA31549@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 02:17:11PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Aug 10, 2009 at 04:53:02PM -0400, Jason Baron wrote:
> > > Make 'perf stat -e syscalls:sys_enter_blah' work with syscall style tracepoints.
> > 
> > 
> > It would be nice to also be able to type:
> > 
> > perf stat -e syscalls:blah
> > 
> > and then having both enter/exit counters.
> 
> Plus wildcard/regex support would be nice as well in the listing of 
> events. That way one could do a shortcut of:
> 
>  perf stat -e syscalls:*
> 
> to trace all syscalls. Or:
> 
>  perf stat -e syscalls:*read*
> 
> to see all the read variants - etc.
> 
> 	Ingo


Plus filters in syscalls field. Because arguments are wrapped and post-processed,
they are not treated as usual fields.
I must confess this part is not trivial though.

