Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbZLJOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbZLJOS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbZLJOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:18:25 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:53840 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760622AbZLJOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:18:24 -0500
Date: Thu, 10 Dec 2009 17:18:30 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: felipe.balbi@nokia.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091210141830.GA10687@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
 <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
 <20091203110332.GO1361@nokia.com>
 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:09:08PM +0200, Grazvydas Ignotas wrote:
[...]
> > dedicated chargers are simple. You kick the charger detection according to
> > USB BC 1.x and if it returns true, you configure high current charging.
> > Host/Hub chargers are also simple, after kicking charger detection, you
> > enable Data pullups (e.g. SOFTCONN bit in musb's power register) and see if
> > the host sends a setup packet...
> >
> > the complicated part is passing the information of which configuration you
> > were enumerated with to the charger chip.
> 
> Ok since it doesn't look like this will resolve soon, what about
> adding some DEVICE_ATTR for the time being and requiring userspace to
> write charge current here to start actual charging?

Works for me. Let's think of the kernel charging support as an
yet unimplemented feature.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
