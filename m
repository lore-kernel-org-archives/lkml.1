Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYGEMKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYGEMKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYGEMKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:10:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35671 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYGEMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:10:00 -0400
Message-ID: <486F6494.8020108@firstfloor.org>
Date: Sat, 05 Jul 2008 14:09:56 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, Andi Kleen <andi@firstfloor.org>,
       Takashi Iwai <tiwai@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       Hannes Reinecke <hare@suse.de>, Theodore Tso <tytso@mit.edu>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de> <1215182557.10393.808.camel@pmac.infradead.org> <20080704231322.GA4410@dspnet.fr.eu.org> <s5h4p746am3.wl%tiwai@suse.de> <20080705105317.GA44773@dspnet.fr.eu.org> <486F596C.8050109@firstfloor.org> <20080705120221.GC44773@dspnet.fr.eu.org>
In-Reply-To: <20080705120221.GC44773@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Sat, Jul 05, 2008 at 01:22:20PM +0200, Andi Kleen wrote:
>> Many distribution have some way for separate kernel module packages.
>> It's essentially the same problem so it should be already solved
>> in some way.
> 
> Errr, no.  Modules go in /lib/modules/`uname -r`, so no conflict.

Well that's the only sane way to store the firmware anyways (otherwise
you could never keep kernel versions which need different firmware installed)

While the current code doesn't do that there have been proposals for that
and I assume/hope they will be acted on.

-Andi

