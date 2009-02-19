Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZBSEJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZBSEJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZBSEJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:09:29 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58726 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZBSEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E6f6hr5xVa8mqf/kEm92hRuqDGpGdxtt8Ftpnlw1W1riBLNgQ8RDl0M9Nx8xGOCgXV
         wnAKAsOtVDW4jVp0DUFpsxDJv9+AZ67bbzm6AlcAZZ2p2ESdjSj3OlxAaIhm6sjLlGpQ
         iYCYg0SHACNRxjJ3QYxB/pbsN/BsU9p4wAIXM=
Date: Thu, 19 Feb 2009 05:09:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] tracing/function-graph-tracer: provide
	documentation for the function graph tracer
Message-ID: <20090219040922.GC5785@nowhere>
References: <499ba227.077e420a.56d6.ffffc38b@mx.google.com> <20090218140150.GA31620@elte.hu> <20090218155827.GA5765@nowhere> <20090218161041.GA29863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218161041.GA29863@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 05:10:41PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Feb 18, 2009 at 03:01:50PM +0100, Ingo Molnar wrote:
> > > 
> > > btw., a minor trace-output observation. We currently have this 
> > > default output:
> > > 
> > > # tracer: function_graph
> > > #
> > > # CPU  DURATION                  FUNCTION CALLS
> > > # |     |   |                     |   |   |   |
> > > 
> > >  0)               |  sys_open() {
> > >  0)               |    do_sys_open() {
> > >  0)               |      getname() {
> > >  0)               |        kmem_cache_alloc() {
> > >  0)   1.382 us    |          __might_sleep();
> > >  0)   2.478 us    |        }
> > > 
> > > Wouldnt this tweaked version look even nicer:
> > > 
> > > #
> > > # [ tracer: function_graph ]
> > > #
> > >  CPU)  <duration>   |  <function-name>
> > >  ..............................................
> > >    0)               |  sys_open() {
> > >    0)               |    do_sys_open() {
> > >    0)               |      getname() {
> > >    0)               |        kmem_cache_alloc() {
> > >    0)   1.382 us    |          __might_sleep();
> > >    0)   2.478 us    |        }
> > > 
> > > 
> > > Changes:
> > > 
> > >  1) Added an empty '#' line to the head. Looks nicer because 
> > >     the comment is now symmetric.
> > 
> > Right.
> >  
> > >  2) Shifted of the CPU field two positions to the left. Better 
> > >     for paste-ability and makes the 'CPU)' header fit as well.
> > 
> > 
> > Good.
> > 
> > 
> > >  3) Changed the field description in the header portion to a 
> > >     standard <field> notation.
> > 
> > 
> > I guess it's more a matter of taste here.
> > I like the uppercase titles because they draw a good separation between
> > titles and traces.
> 
> hm, to me they look a bit sloppy. It's hard to align them to the 
> colums so they look detached - despite the '| | |' vertical 
> lines. Unless you find the <field> notation outright ugly, could 
> we try that and see how it goes?
> 
> 	Ingo

Sure! I will send an RFC and wait for opinions...

