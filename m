Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZKMX2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZKMX2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932599AbZKMX2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZKMX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:26 -0500
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091113224009.GB23942@elte.hu>
References: <1258115870.6167.4.camel@johannes.local>
	 <20091113224009.GB23942@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 13 Nov 2009 18:28:29 -0500
Message-Id: <1258154909.22249.211.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 23:40 +0100, Ingo Molnar wrote:
> ( extended the Cc:s. Please try to Cc: people you think would be 
>   interested in your patches. )

Thanks Ingo.

> 
> * Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > For some reason the export of the event print
> > format to userspace uses '#fmt' which breaks
> > if the format string is anything but a plain
> > string, for example if it is built with macros
> > then the macro names are exported instead of
> > their contents.
> > 
> > Use
> > 	"\"%s\"", fmt
> > instead of
> > 	"%s", #fmt
> > to export the string and not the way it is built.

Is there any examples of this currently in the kernel? If so could you
show that in the changlog.

But other than that, the change looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---


