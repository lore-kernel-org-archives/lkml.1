Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYLaBsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYLaBsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYLaBrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:47:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:56967 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYLaBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IZx4YhiZdmsarBoioE4k6rOE7oGp94BF11wjPE7glL3hIVP/NJ/piNrERIow0S7p6r
         NVIJp+m7vUSUbVbQZ/08OwqwUmkvkVyl/f7H0NqK1tVhDOMPpQz93p1cIQ1zGrKIoliv
         lv1ASfGr9QZ+uJnOB+7vq2RIqimUqtEo4hB1Q=
Date: Wed, 31 Dec 2008 02:47:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
Message-ID: <20081231014747.GB28472@nowhere>
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org> <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere> <495AC45D.8010102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495AC45D.8010102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:01:17PM -0800, H. Peter Anvin wrote:
> Frederic Weisbecker wrote:
> > On Tue, Dec 30, 2008 at 04:34:00PM -0800, H. Peter Anvin wrote:
> >> H. Peter Anvin wrote:
> >>> Applied to tip:tracing/kmemtrace2.
> >>>
> >> Hm, there still seems to be a build failure, in particular
> >> trace_output.h is missing.  It looks to me at the moment as if just
> >> removing the #include works; assuming that compiles I will check that in
> >> to tip:tracing/kmemtrace2 as well.
> >>
> >> 	-hpa
> > 
> > While I worked on this tracer, I had to base the thing against tracing/kmemtrace
> > because I needed the kmemtrace bits.
> > But I saw that this topic was a bit out of sync against tip/master, some updates from
> > Steven were not merged. But I didn't wonder, thinking that Ingo would resolve the
> > conflicts. But it seems there were some lost stuffs :-)
> > 
> > I'm checking it and will send a patch to solve the rest...
> > 
> 
> If it's only the trace_output.h #include removal, don't worry about it;
> I'm about to commit that patch, but it would be good if you could check
> out the tracing/kmemtrace2 branch afterwards.


Yes this topic builds well after your patch. So it was just this header.

Thanks!

