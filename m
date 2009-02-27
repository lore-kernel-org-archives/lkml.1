Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZB0Vix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZB0Vix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbZB0Viq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:38:46 -0500
Received: from fifo99.com ([67.223.236.141]:46310 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZB0Vip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:38:45 -0500
Subject: Re: [PATCH] Don't profile branches in arm's boot decompressor
From: Daniel Walker <dwalker@fifo99.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@rostedt.homelinux.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090227212809.GA5338@pengutronix.de>
References: <1235768983-4830-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1235769587.8233.1.camel@desktop>  <20090227212809.GA5338@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Feb 2009 13:38:44 -0800
Message-Id: <1235770725.8233.4.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 22:28 +0100, Uwe Kleine-König wrote:
> Hi Daniel,
> 
> On Fri, Feb 27, 2009 at 01:19:47PM -0800, Daniel Walker wrote:
> > On Fri, 2009-02-27 at 22:09 +0100, Uwe Kleine-König wrote:
> > > This fixes many compile errors for arch/arm/boot/compressed/misc.c of
> > > the type:
> > > 
> > > 	arch/arm/boot/compressed/misc.c:127: error: section attribute cannot be specified for local variables
> > 
> > Why do you think this error showed up just in that one file? It looks
> > like the branch tracer puts section tags on non-globals all over the
> > kernel..
> With this patch I was able to compile an ARM kernel with profiling
> enabled.  Is that enough justification?

I'm not asking for any sort of justification .. I'm just wondering if
you know why that error is showing up there and not in other places..

Daniel

