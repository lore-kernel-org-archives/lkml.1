Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYIHR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYIHR7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYIHR7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:59:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYIHR7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:59:21 -0400
Date: Mon, 8 Sep 2008 19:59:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rambaldi <rambaldi@xs4all.nl>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
Message-ID: <20080908175906.GA29264@elte.hu>
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C457DC.9050904@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Rambaldi wrote:
> > Hi,
> >
> > when running the 2.6.27-rc5 kernel as 64 bits dumU I get the following
> > warnings:
> 
> This patch, change 167e6cf62979df03513898966f9227847d192327 in tip.git,
> should fix this.  I'm not sure if the other sysfs changes apply to
> mainline git or not.
> 
> Could you try this and see how it goes?  The first chunk should be
> sufficient to fix your problem.

We could certainly propagate it to x86/urgent, if it fixes a real issue. 
It cherry-picks just fine.

	Ingo
