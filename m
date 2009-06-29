Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZF2LTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZF2LTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZF2LTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:19:04 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46932 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZF2LTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O+TVmGV+vawH3TtcawUQvQipwrwwnOQ7SvUTcGbX7jCqY10Q655N01+HqgHnVkQbhC
         uqwHlUZHtDc0pEdCgtUMbQysBBcKdyQO+5tnwoPQVhtW4MJoN9BIAJ5Oik9JdxpkNeJ9
         lzwdD7DQ8oH1204eri+O6nazQ6wbESdVMidQ8=
Date: Mon, 29 Jun 2009 13:19:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/fastboot: document the need of initcall_debug
Message-ID: <20090629111901.GB6265@nowhere>
References: <4A48735E.9050002@cn.fujitsu.com> <20090629082152.GA2921@elte.hu> <4A488304.9000104@cn.fujitsu.com> <20090629091422.GA9724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629091422.GA9724@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:14:22AM +0200, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > 
> > >> To use boot tracer, one should pass initcall_debug as well as
> > >> ftrace=initcall to the command line.
> > > 
> > > I think both should be auto-enabled if BOOT_TRACER is enabled, for 
> > > ease of use - agreed?
> > 
> > If both are auto-enabled, we'll always do boot tracing. But we 
> > want BOOT_TRACER to be enabled and only enable boot tracing when 
> > it's needed.
> > 
> > But maybe we can make ftrace=initcall implies initcall_debug=1?
> 
> That's reasonable indeed.
> 
> 	Ingo

Yeah.

Although I wonder if this tracer is still useful.
It was first written to debug fastboot, to get more
than the initcall_debug output, ie: the scheduling
events but now I guess the latter is not useful
anymore. And using initcall_debug already does the
job of printing the initcall events.

What do you think?

