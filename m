Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYIUXpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYIUXpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 19:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIUXpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 19:45:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:54781 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYIUXpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 19:45:15 -0400
Date: Mon, 22 Sep 2008 03:44:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921234403.GA17946@2ka.mipt.ru>
References: <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921124332.67ddc13a@infradead.org> <20080921202057.GB25052@2ka.mipt.ru> <20080921132753.5689b564@infradead.org> <20080921205706.GA24545@2ka.mipt.ru> <20080921233819.32714483@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921233819.32714483@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 11:38:19PM +0100, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > still more complex than needed; a WARN_ON_ONCE() will be enough.
> > 
> > That allows to dump whatever number of warnings you want. The more we
> > have, the louder will be customers scream.
> 
> But if Intel don't care then you can scream all you like 8)

That's what happens :)

> A WARN_ON_ONCE is sufficient to capture an idea of how many people it is
> effecting and maybe to figure out what the trigger is from their reports,
> at that point there is some chance to get it fixed (especially if its
> remotely triggerable ;))

Well, redhat, suse and ubuntu bugzillas happend to be not enough. Why do
you believe a single warning at a new place will be? or couple of tens
or whatever else? If it cares, it cares. If it does not...

I attracted vendor's attention, vendor told me to fix it myself and to
create a patch to fill an entry in another 'bugzilla', so that vendor
could get results and probably decide to walk down from the cloud and
fix it.

So, if they do not care, I do not care about their care. That's the
deal. I will try to find a workaround, even if it is a real crap,
fortunately other users will not strike this bug too frequently.

-- 
	Evgeniy Polyakov
