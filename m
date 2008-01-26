Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYAZAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYAZAFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYAZAFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:05:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbYAZAFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:05:45 -0500
Date: Sat, 26 Jan 2008 01:05:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080126000526.GA24559@elte.hu>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de> <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org> <479A3ED3.6020808@goop.org> <1201296027.32422.80.camel@perihelion> <alpine.LFD.1.00.0801251347010.5056@hp.linux-foundation.org> <479A5B72.6080701@goop.org> <1201299979.27573.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201299979.27573.11.camel@lappy>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> My wish is that distros would just boot without requiring an initrd. I 
> know how to make them for redhat and debian based distros, but the 
> fact that you can't (easily) cross-build them makes it a very tedious 
> construct.

all it takes for me on Fedora is to boot a modular distro kernel once, 
then copy the /dev to the real (persistent) /dev:

   mkdir /tmp2
   mount /dev/sda1 /tmp2
   cp -a /dev/* /tmp2/dev/

and from that point on a bzImage/vmlinuz can boot up on Fedora without 
any problems (as long as it has the right drivers built in), and the 
initrd line can be removed from grub.conf.

	Ingo
