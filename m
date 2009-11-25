Return-Path: <linux-kernel-owner+w=401wt.eu-S934557AbZKYJCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbZKYJCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934471AbZKYJCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:02:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933884AbZKYJCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:02:39 -0500
Date: Wed, 25 Nov 2009 10:02:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bernd Petrovitsch <bernd@firmix.at>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: cannot compile linux-2.6-tip tree
Message-ID: <20091125090216.GE1940@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
 <20091124154511.GG21821@elte.hu>
 <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
 <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
 <1259124929.22249.1133.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259124929.22249.1133.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:55:29PM -0500, Steven Rostedt wrote:
> On Tue, 2009-11-24 at 23:27 +0100, Bernd Petrovitsch wrote:
> > On Die, 2009-11-24 at 18:22 +0100, Jiri Olsa wrote: 
> > > On Tue, Nov 24, 2009 at 04:45:11PM +0100, Ingo Molnar wrote:
> > [...] 
> > > > It's rare but happens. 'make clean' will cure that.
> > Apart from disk full, hitting quota limits may give similar errors.
> 
> Yeah, the box I tested your config on filled up before finishing. But it
> made it to the linking of the vmlinux before it died.
> 
> I did a:
> 
>  $ cd linux.git
>  $ git checkout 2e7c0e0cafee # what you showed was the problem
>  $ mkdir ../tmp
>  $ cp ~/olsa-config ../tmp/.config
>  $ make O=../tmp
> 
> 
> When it died, tmp was 7964.05 MB in size!

wow :) new tree clone with the same config works for me

jirka

> 
> -- Steve
> 
> 
