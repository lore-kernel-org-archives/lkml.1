Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYGIUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYGIUYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYGIUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:24:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYGIUYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:24:13 -0400
Date: Wed, 9 Jul 2008 22:23:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies (was:
	Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709202345.GG14009@elte.hu>
References: <patchbomb.1215554782@localhost> <200807092202.27013.rjw@sisk.pl> <20080709200428.GB14009@elte.hu> <200807092217.53222.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092217.53222.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> >  config PM_SLEEP
> >  	bool
> > -	depends on SUSPEND || HIBERNATION
> > +	depends on SUSPEND || HIBERNATION || XEN
> >  	default y
> >  
> >  config SUSPEND
> 
> I don't like this.
> 
> I'll have a look at the remaining related patches and see what can be 
> done.
> 
> Jeremy, what exactly do you need the !PM && PM_SLEEP combination for, 
> BTW?

ok, i've reverted this from tip/master now, until you and Jeremy work 
out the details. (it shouldnt be a big limitation on xen64 anyway)

	Ingo
