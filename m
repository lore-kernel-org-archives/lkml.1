Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXJJHmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXJJHmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbXJJHmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:42:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbXJJHmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:42:37 -0400
Date: Wed, 10 Oct 2007 09:42:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [PATCH sched-devel] Generate uevents for user
	creation/destruction
Message-ID: <20071010074218.GA31441@elte.hu>
References: <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu> <20071004085451.GA8108@osiris.boeblingen.de.ibm.com> <20071009151201.GK3707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009151201.GK3707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> > Shouldn't that be done via uevents? E.g. UID x gets added to the 
> > sysfs tree, generates a uevent and a script then figures out the 
> > cpu_share and sets it. That way you also don't need to keep the 
> > directories. No?
> 
> Heiko,
> 	Thanks for the hint. Here's a patch to enable generation of 
> uevents for user creation/deletion. These uevents can be handled in 
> userspace to configure a new user's cpu share.
> 
> Note : After bootup I could test that new user's cpu share is 
> configured as per a configuration file (/etc/user_cpu_share.conf). 
> However this mechanism didnt work for root user. Perhaps uevent for 
> root user is generated way too early?
> 
> A HOWTO text file is also attached explaining how to make use of these 
> uevents in userspace.
> 
> Ingo,
> 	This patch applies on top of latest sched-devel tree. Pls 
> review and apply ..

thanks, applied. This looks reassuringly simple and straightforward!

	Ingo
