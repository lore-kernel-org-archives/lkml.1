Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYDKBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYDKBey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYDKBeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:34:44 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:47432
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbYDKBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:34:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8AAJpd/kd8qMLf/2dsb2JhbAAIq0g
X-IronPort-AV: E=Sophos;i="4.25,638,1199631600"; 
   d="scan'208";a="248542701"
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
From: Ben Nizette <bn@niasdigital.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080410211717.GG3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <20080410195438.GE3193@local> <20080410200819.GA16292@digi.com>
	 <20080410211717.GG3193@local>
Content-Type: text/plain; charset=utf-8
Organization: Nias Digital
Date: Fri, 11 Apr 2008 11:34:34 +1000
Message-Id: <1207877674.3827.21.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-10 at 23:17 +0200, Hans J. Koch wrote:
> On Thu, Apr 10, 2008 at 10:08:19PM +0200, Uwe Kleine-König wrote:
> > On Thu, Apr 10, 2008 at 02:37:03PM +0200, Uwe Kleine-König wrote:
> > > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > > ---
> > >  drivers/uio/Kconfig    |    7 ++
> > >  drivers/uio/Makefile   |    1 +
> > >  drivers/uio/uio_pdrv.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 173 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/uio/uio_pdrv.c
> > 
> > I'm a bit slow today, I don't really understand what this is good for.
> > It's to complicated to serve as a template, and it doesn't support
> > interrupts, so it's not good for any real device, too. So the only
> > usecase would be an irq-less platform_device that just needs its memory
> > mapped. Is this what you intended? What do _you_ use it for?

I've seen this kind of thing hacked up by a few people already, mainly
as a replacement for /dev/mem.  Many people are being scared off
using /dev/mem (and rightly so) because
- They've seen discussions regarding future plans whereby /dev/mem
wouldn't be allowed access to physical memory
- They don't have anything like X forcing them to have /dev/mem and
therefore want to disable it completely for (perceived?) security
reasons.

I like it, it'll sure be used.

	--Ben.


