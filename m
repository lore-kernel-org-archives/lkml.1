Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYARLsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYARLsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYARLsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:48:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbYARLso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:48:44 -0500
Date: Fri, 18 Jan 2008 12:48:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118114823.GA8583@elte.hu>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <1200653448.5724.135.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200653448.5724.135.camel@brick>
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

> 
> On Fri, 2008-01-18 at 11:44 +0100, Ingo Molnar wrote:
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > >  # Select 32 or 64 bit
> > >  config 64BIT
> > > -	bool "64-bit kernel" if ARCH = "x86"
> > > +	bool "64-bit kernel"
> > >  	default ARCH = "x86_64"
> > >  	help
> > >  	  Say yes to build a 64-bit kernel - formerly known as x86_64
> > 
> > thx, i've added this to x86.git.
> 
> Style question, would the following be preferred?
> 
> config 64BIT
> 	def_bool ARCH = "x86_64"
> 	prompt "64-bit kernel"
> 	help...

sure, we could do that too.

	Ingo
