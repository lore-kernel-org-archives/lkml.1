Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbZDAWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbZDAWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZDAWQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:16:05 -0400
Received: from sous-sol.org ([216.99.217.87]:48281 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbZDAWQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:16:04 -0400
Date: Wed, 1 Apr 2009 15:14:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
Message-ID: <20090401221433.GV18394@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904012329.21362.rjw@sisk.pl> <20090401213756.GU18394@sequoia.sous-sol.org> <200904012349.10919.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012349.10919.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Wednesday 01 April 2009, Chris Wright wrote:
> > * Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > > This may be caused by the recent PM changes.  Can you please test if commit
> > > 8efb8c76fcdccf5050c0ea059dac392789baaff2 is fine?
> > 
> > I just tested on my t400, it's not[1].  See same symptoms as Arkadiusz.
> > Seems as if it responds to initial apci event, I see some disk activity,
> > then nothing (as if it tried to wakeup, then went back to sleep).
> > 
> > [1] 15f7176eb1cccec0a332541285ee752b935c1c85 bad
> >     fae3e7fba4c664b3a15f2cf15ac439e8d754afc2 good(ish) (display stays blank)
> 
> Hmm, can you also test commit 0a0c5168df270a50e3518e4f12bddb31f8f5f38f, please?

Well, that's already included in 15f7176eb1cccec0a332541285ee752b935c1c85
