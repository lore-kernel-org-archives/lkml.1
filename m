Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYGDXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYGDXNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYGDXN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:13:29 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4495 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYGDXN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:13:28 -0400
Date: Sat, 5 Jul 2008 01:13:22 +0200
From: Olivier Galibert <galibert@pobox.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Takashi Iwai <tiwai@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704231322.GA4410@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Hannes Reinecke <hare@suse.de>, Takashi Iwai <tiwai@suse.de>,
	Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>, hugh@veritas.com,
	akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
	mchan@broadcom.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org
References: <20080703.162120.206258339.davem@davemloft.net> <486D6DDB.4010205@infradead.org> <87ej6armez.fsf@basil.nowhere.org> <1215177044.10393.743.camel@pmac.infradead.org> <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de> <1215182557.10393.808.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215182557.10393.808.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 03:42:37PM +0100, David Woodhouse wrote:
> It doesn't yet; that patch is in linux-next. The firmware is shipped as
> part of the kernel source tree, and you currently need to run 'make
> firmware_install' to put it in /lib/firmware, although we're looking at
> making that easier because apparently having to run 'make
> firmware_install' is too hard...

Won't that break multiple kernel installs on any binary packaging
system that cares about file collisions?  Multiple kernel rpms
providing the same /lib/firmware files would break things wouldn't
they ?

  OG.

