Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbZD2Pta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbZD2Pta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZD2PtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:49:20 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56564 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZD2PtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H2Xag6g7RK1/UYzmU/WOKHjrkHoGLo+mfWSs8L2KO6+LdHcM/KeKHtQ2fC58PIG9bn
         U0jCBh/dWQoPEzPMKRQasyTPgV9m57vMQ2kNMNxPnXUyO2dcBtdMPu1E1+i80EIm+nxt
         luOeX4/nQ+97Ds2eTujonU02Yv4Wkshxm5TAQ=
Date: Wed, 29 Apr 2009 17:49:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] workqueue_trace: Add max execution time mesurement
	for per worklet
Message-ID: <20090429154913.GA6406@nowhere>
References: <49F6DFB5.2040901@cn.fujitsu.com> <20090429000616.f7e72b73.akpm@linux-foundation.org> <20090429133342.GA5987@nowhere> <alpine.DEB.2.00.0904290944290.8066@gandalf.stny.rr.com> <20090429083654.7ecf0100.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429083654.7ecf0100.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 08:36:54AM -0700, Andrew Morton wrote:
> On Wed, 29 Apr 2009 09:45:28 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Wed, 29 Apr 2009, Frederic Weisbecker wrote:
> > >  * pointer to the real address.
> > > 
> > > But the output formatting is the same: address, offset, size, modname.
> > > 
> > > I found it a bit annoying, so I proposed the following patch recently:
> > > 
> > > http://lkml.org/lkml/2009/4/15/310
> 
> This looks OK.  I'd assumed it was merged.  Was there a problem with it?



No, I tested it without problem.


 
> > > And someone came with a better idea, IMO:
> > > 
> > > http://lkml.org/lkml/2009/4/17/105
> > 
> > Note,
> > 
> > If these ever do get merged, I would be happy to convert ftrace to use 
> > them to replace my version.
> 
> I spose I could use magic powers to sneak it into .30?


Thanks :)

