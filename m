Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbZDCRru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbZDCRru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933728AbZDCRre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:47:34 -0400
Received: from sous-sol.org ([216.99.217.87]:37221 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935336AbZDCRrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:47:32 -0400
Date: Fri, 3 Apr 2009 10:45:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090403174540.GB27148@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904030222.57469.a.miskiewicz@gmail.com> <20090403003523.GK18394@sequoia.sous-sol.org> <200904030847.19674.a.miskiewicz@gmail.com> <20090403173631.GA27148@sequoia.sous-sol.org> <20090403173955.GD6295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403173955.GD6295@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > On Friday 03 of April 2009, Chris Wright wrote:
> > > > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > > > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> > > > >
> > > > > stop_machine: introduce stop_machine_create/destroy.
> > > >
> > > > That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
> > > >
> > > > Can you please verify if 2.6.29 works for you? 
> > > 
> > > I think that the guilty part is 
> > > CONFIG_CC_STACKPROTECTOR_ALL=y
> > > CONFIG_CC_STACKPROTECTOR=y
> > 
> > Indeed, I think you're right.  In fact...this should fix it:
> 
> Note that i had to do a manual merge of the patch (it had 3 separate 
> patch corruptions) - the non-damaged version i applied is the one 
> below.

Indeed, I just discovered that ;-)

And, for the record...yes, that fixes it on my laptop.

Tested-by: Chris Wright <chrisw@sous-sol.org>

