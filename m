Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZGCNJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZGCNJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZGCNJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:09:41 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:47680 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZGCNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CWoOkb1TcUNqpcDf+Z3+T1mXKn9iL17T3gwqLbmXHP+qc9XVTZp0HVCbFLvitZqvpP
         8xsN3idumbBDkWBXJm1UFnuLrn4SntsVmqpch8vyeXalJ/MyOI9I8hHZPDbM98tSdr3P
         BKVVpA5aPsocxz0K3u9bWx/0lADAQ8/4xXOo0=
Date: Fri, 3 Jul 2009 15:09:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Anton Blanchard <anton@samba.org>,
       Sam Ravnborg <sam@ravnborg.org>, Peter Zijlstra <peterz@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf tools: gitignore *.data
Message-ID: <20090703130936.GA5072@nowhere>
References: <1246603147.2322.3.camel@jaswinder.satnam> <20090703103852.GA3242@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703103852.GA3242@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 12:38:52PM +0200, Ingo Molnar wrote:
> 
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > perf.data made by perf record is a data file and need to be 
> > ignored by git
> > 
> > Added *.data so that perf.data and its friends will be ignored.
> 
> >  cscope*
> > +*.data
> 
> ok, this is something i wanted to revisit eventually - the 
> 'perf.data' name sucks a bit - as .data postfix is quite unspecific.
> 
> Perhaps trace.perf is a better default name, and all files would 
> have the .perf postfix?
> 
> I've Cc:-ed a number of folks who might have an opinion about this - 
> what would be the best default naming and postfix for perf binary 
> files?
> 
> 	Ingo


perf.bin seems to me adequate as it tells everything (IMHO).

