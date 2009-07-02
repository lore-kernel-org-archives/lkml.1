Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZGBGlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZGBGlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZGBGla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:41:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42292 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZGBGl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cOAzTc4RK7pNtph5ASSmyL7SsLJf7NI5sV8SounkHhI2IaC3699lIP76Bk20307XY9
         WwDrUlxODKLaKGTSEyAMMibML2+ESIqsdbjVJra0Qxm6NdBp2hQB+JoXZVdljuLfkcHt
         KJ9GwnGBIbj99Wvfuqar6EY73id58wy1k8FH4=
Date: Thu, 2 Jul 2009 09:42:21 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemtrace: print binary output only if 'bin' option is
	set
Message-ID: <20090702064221.GA2153@localhost>
References: <4A4C4FEA.6010109@cn.fujitsu.com> <1246516313.6461.0.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246516313.6461.0.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:31:52AM +0300, Pekka Enberg wrote:
> Hi Li,
> 
> On Thu, 2009-07-02 at 14:12 +0800, Li Zefan wrote:
> > Currently by default the output of kmemtrace is binary format instead
> > of human-readable output.
> > 
> > This patch makes the following changes:
> >   - We'll see human-readable output by default
> >   - We'll see binary output if 'bin' option is set
> > 
> > Note: you may probably need to explicitly disable context-info binary
> >       output:
> > 
> > 	# echo 0 > options/context-info
> > 	# echo 1 > options/bin
> > 	# cat trace_pipe
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> I'm fine with this. Eduard?
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

I'm okay, will make the necessary changes to kmemtrace-user.

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

