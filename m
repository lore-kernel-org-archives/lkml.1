Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYAJMq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYAJMq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYAJMqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:46:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60472 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYAJMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:46:18 -0500
Date: Thu, 10 Jan 2008 13:46:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
	traditional
Message-ID: <20080110124606.GD15156@elte.hu>
References: <20080109220508.686bbda4@laptopd505.fenrus.org> <1199946105.19760.5.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199946105.19760.5.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Wed, 2008-01-09 at 22:05 -0800, Arjan van de Ven wrote:
> > Subject: Make the 32 bit Frame Pointer backtracer fall back to traditional
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > The 32 bit Frame Pointer backtracer code checks if the EBP is valid
> > to do a backtrace; however currently on a failure it just gives up
> > and prints nothing. That's not very nice; we can do better and still
> > print a decent backtrace. 
> > 
> > This patch changes the backtracer to fall back to the non-framepointer
> > backtracer if the EBP value isn't within the expected range; so on weird
> > stack corruption cases we get at least something out...
> > 
> 
> Arjan, I've been doing some work on traps_32.c porting over the 
> oops_begin()/oops_end()/_die() arrangement from traps_64.c and then 
> use it in unifying some more parts of fault.c.

i've got that applied and it did not seem to interact with Arjan's code.

> If you have other work in this area, I'll hold off until your stuff 
> goes in...feel free to send me any work in progress stuff and I can 
> try to coordinate with you.

i'll yell if anything clashes.

	Ingo
