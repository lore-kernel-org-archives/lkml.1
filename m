Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZKOIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZKOIRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZKOIRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:17:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZKOIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:17:38 -0500
Date: Sun, 15 Nov 2009 09:17:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lihong.hi@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + recordmcount-stfu.patch added to -mm tree
Message-ID: <20091115081736.GA29826@elte.hu>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
 <1258174705.22249.236.camel@gandalf.stny.rr.com>
 <20091113212645.3956bc85.akpm@linux-foundation.org>
 <1258176822.22249.239.camel@gandalf.stny.rr.com>
 <20091114092718.GA10969@elte.hu>
 <1258231467.22249.438.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258231467.22249.438.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2009-11-14 at 10:27 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Fri, 2009-11-13 at 21:26 -0800, Andrew Morton wrote:
> > > 
> > > > Dunno, really.  How many people are running old objdump, and do we 
> > > > want to retard the rate at which the stragglers will upgrade?
> > > 
> > > I guess not, but by printing out a warning 
> > > 1000000000000000000000000000 times per build, it may encourage them to 
> > > upgrade ;-)
> > 
> > If that binutils version is still supported this is not the right 
> > method. People are in their full rights to be at any version within the 
> > supported versions interval, and we should not 'force' them.
> 
> It's not forcing them. [...]

My point was that by printing a warning 1000000000000000000000000000 
times per build we effectively force them, by making life unpleasant.

	Ingo
