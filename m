Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZIKPny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZIKPny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZIKPnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:43:53 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36017 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZIKPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=EST23bZ+yW4fZITlEXWaWkc/EZUZUUAfEM0LWyYLiLcjmPBYoPgET/PB2V3cjqtaH3
         6QmsqxTMMzHoGHr++dLmDTVNFHxUXvpGdfuOKnUTd0ETRLLleK7Dh3jJP7FtjfL+aN4C
         2LnexZfSzCcU9FPNSbGoGRkX3OG5oczHZLV/8=
Date: Fri, 11 Sep 2009 17:43:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
	tracer
Message-ID: <20090911154349.GB6069@nowhere>
References: <20090911135452.866274568@goodmis.org> <20090911135626.824079836@goodmis.org> <20090911145521.GA6119@nowhere> <1252681916.18996.697.camel@gandalf.stny.rr.com> <20090911151811.GB6119@nowhere> <4AAA6EE2.8000807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AAA6EE2.8000807@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 06:38:10PM +0300, Török Edwin wrote:
> On 2009-09-11 18:18, Frederic Weisbecker wrote:
> > On Fri, Sep 11, 2009 at 11:11:56AM -0400, Steven Rostedt wrote:
> >   
> >> On Fri, 2009-09-11 at 16:55 +0200, Frederic Weisbecker wrote:
> >>
> >>     
> >>> Oh, BTW, what would you think about addding the current->lock_depth
> >>> in the latency format? That may help debug the bkl...
> >>>       
> >> Hmm, that would require adding another field for all traces. I don't
> >> want to increase the size of an entry unneeded. BTW, this is for all
> >> entries (even events).
> >>     
> >
> >
> > Right...
> >
> >  
> >   
> >> Ug! I just noticed that tgid was added to struct trace_entry, with the
> >> only user as the user stack entry. This should be in the user stack
> >> field not something that goes into every event!
> >>
> >> I guess I need to fix that too.
> >>     
> 
> Indeed tgid should be part of struct userstack_entry, and set in
> ftrace_trace_userstack.
> Do you want to me to write up a patch for that, or have you already
> fixed it?
> 
> Best regards,
> --Edwin


No, please do.

Thanks!

