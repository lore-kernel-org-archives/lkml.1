Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZJGBT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZJGBT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758477AbZJGBT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:19:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbZJGBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:26 -0400
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
 match interrupt.h
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, lizf@cn.fujitsu.com
In-Reply-To: <20091006214228.GB5343@nowhere>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
	 <1254808849-7829-3-git-send-email-tzanussi@gmail.com>
	 <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere>
	 <20091006152106.GA6490@infradead.org> <20091006152255.GC5152@nowhere>
	 <20091006152419.GA10501@infradead.org>  <20091006214228.GB5343@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 21:17:27 -0400
Message-Id: <1254878247.1696.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 23:42 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 06, 2009 at 11:24:19AM -0400, Christoph Hellwig wrote:
> > On Tue, Oct 06, 2009 at 05:22:58PM +0200, Frederic Weisbecker wrote:
> > > I see...
> > > Then the only solution I can imagine is to export a debugfs file
> > > in the tracing directory that provides this name resolution.
> > 
> > The format files kinda contain that information, just not in a very
> > useful format.  I think the general problem is that the formats exported
> > aren't descriptive enough, and fields/flags are just one symptom of
> > that.
> 
> 
> Well, Steve has posted a whole rewrite of the format files some months ago,
> I don't know what's the status of this work. One of the problems is that we
> know have tools that support the current format.
> 

Yeah, but that new format was just begging for a NAK. No one wants a new
format layout. They want C code. But unfortunately, when we use enums
for flags and such, the macros have no idea how to handle it. I may try
to work out a way to let those same macros be able to export the value
with the enum name.

I'll try to figure out something.

-- Steve


