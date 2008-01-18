Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbYARRBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbYARRBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761241AbYARRBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:01:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761076AbYARRBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:01:01 -0500
Date: Fri, 18 Jan 2008 18:00:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118170037.GA23297@elte.hu>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118104401.GA8785@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> >  # Select 32 or 64 bit
> >  config 64BIT
> > -	bool "64-bit kernel" if ARCH = "x86"
> > +	bool "64-bit kernel"
> >  	default ARCH = "x86_64"
> >  	help
> >  	  Say yes to build a 64-bit kernel - formerly known as x86_64
> 
> thx, i've added this to x86.git.

this broke "make ARCH=i386 randconfig" from working when there's a 
64-bit .config present. (it will not properly generate a 32-bit config, 
but still a 64-bit config)

	Ingo
