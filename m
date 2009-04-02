Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZDBVHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZDBVHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZDBVHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:07:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbZDBVHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:07:01 -0400
Date: Thu, 2 Apr 2009 23:04:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090402210451.GA4076@elte.hu>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904020023.58363.rjw@sisk.pl> <20090401230637.GW18394@sequoia.sous-sol.org> <200904022300.01707.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904022300.01707.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Thursday 02 April 2009, Chris Wright wrote:
> > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > Sorry for the misunderstanding, I thought the breakage might be introduced
> > > between 15f7176eb1cccec0a332541285ee752b935c1c85 and
> > > 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, so I thought it would be a good
> > > idea to verify if 0a0c5168df270a50e3518e4f12bddb31f8f5f38f fails too.
> > 
> > Ah, sure.  It fails too (both test_suspend=mem and regular suspend/resume).
> 
> Having looked at the commit the Arek's bisect turned up I don't 
> think it's likely to have caused this problem to appear.
> 
> It seems that the regression had been introduced before the PM and 
> PCI updates went it, so I bet it's one of the x86 changes.  Ingo, 
> are there any commits obviously worth testing?

i lost context - a list/range of commits to check would be nice.

	Ingo
