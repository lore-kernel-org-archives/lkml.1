Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbZLJOoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbZLJOoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZLJOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:44:07 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:53891 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752494AbZLJOoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:44:05 -0500
Date: Thu, 10 Dec 2009 17:44:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091210144411.GA13120@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
 <20091203110332.GO1361@nokia.com>
 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
 <20091210141830.GA10687@oksana.dev.rtsoft.ru>
 <20091210142127.GB12526@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091210142127.GB12526@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:21:27PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Dec 10, 2009 at 03:18:30PM +0100, ext Anton Vorontsov wrote:
> >>Ok since it doesn't look like this will resolve soon, what about
> >>adding some DEVICE_ATTR for the time being and requiring userspace to
> >>write charge current here to start actual charging?
> >
> >Works for me. Let's think of the kernel charging support as an
> >yet unimplemented feature.
> 
> but if you guys are ok with this one for now. It can always be
> changed later :-)

Yep. The only thing I'm afraid of is that once the driver is in,
then nobody will bother with improving it to do the right thing.
But an imperfect driver is better than none.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
