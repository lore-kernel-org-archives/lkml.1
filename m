Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYARMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYARMDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARMDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:03:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYARMDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:03:13 -0500
Date: Fri, 18 Jan 2008 13:02:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118120248.GA11044@elte.hu>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <1200653448.5724.135.camel@brick> <20080118113744.GA17447@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118113744.GA17447@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > Style question, would the following be preferred?
> > 
> > config 64BIT
> > 	def_bool ARCH = "x86_64"
> > 	prompt "64-bit kernel"
> > 	help...
> 
> No.
> It is most common to let the prompt follow the type and not
> as a separate property.

hm, ok. I guess there's not much cleanliness difference between:

    bool "64-bit kernel"
    default ARCH = "x86_64"

and:

    def_bool ARCH = "x86_64"
    prompt "64-bit kernel"

	Ingo
