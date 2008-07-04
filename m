Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYGDOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYGDOnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYGDOnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:43:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYGDOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:43:00 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
In-Reply-To: <486E3622.1000900@suse.de>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	 <20080703173040.GB30506@mit.edu>
	 <1215111362.10393.651.camel@pmac.infradead.org>
	 <20080703.162120.206258339.davem@davemloft.net>
	 <486D6DDB.4010205@infradead.org>	<87ej6armez.fsf@basil.nowhere.org>
	 <1215177044.10393.743.camel@pmac.infradead.org>
	 <486E2260.5050503@garzik.org>
	 <1215178035.10393.763.camel@pmac.infradead.org>
	 <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de>
	 <486E3622.1000900@suse.de>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 15:42:37 +0100
Message-Id: <1215182557.10393.808.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 16:39 +0200, Hannes Reinecke wrote:
> Firmware loading is just a matter of copying the file at the correct
> location (ie /lib/firmware) and with the name the fw loader expects.
> mkinitrd should do it correctly.
> But I wasn't aware that the tg3 has external firmware, so I doubt
> we have any rpm for it.

It doesn't yet; that patch is in linux-next. The firmware is shipped as
part of the kernel source tree, and you currently need to run 'make
firmware_install' to put it in /lib/firmware, although we're looking at
making that easier because apparently having to run 'make
firmware_install' is too hard...

-- 
dwmw2

