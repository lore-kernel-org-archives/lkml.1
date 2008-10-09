Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYJIMbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYJIMbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbYJIMbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:31:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895AbYJIMbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:31:21 -0400
Date: Thu, 9 Oct 2008 14:31:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>
Subject: Re: [patch] clean hex output of ftrace
Message-ID: <20081009123113.GB2952@elte.hu>
References: <Pine.LNX.4.30.0810081715520.2487-100000@perches.com> <1223513095.8195.113.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223513095.8195.113.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Wed, 2008-10-08 at 17:16 -0700, Joe Perches wrote:
> > On Wed, 8 Oct 2008, Harvey Harrison wrote:
> > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > Subject: [PATCH] ftrace: Fix inversion of hex output and use common routines
> > 
> > You're quick...
> > 
> > >  	BUG_ON(len >= HEX_CHARS);
> > 
> > I think the BUG_ON is senseless.
> > 
> 
> Agreed, it probably meant to say BUG_ON(len * 2 > HEX_CHARS -1)
> 
> But as this is only called from within a helper macro, it could be
> changed to a build-time check instead of a runtime:
> 
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Subject: [PATCH] trace: add build-time check to avoid overrunning hex buffer

applied to tip/tracing/core:

 bb86ba7: trace: add build-time check to avoid overrunning hex buffer
 32ce86f: ftrace: fix hex output mode of ftrace

thanks guys!

	Ingo
