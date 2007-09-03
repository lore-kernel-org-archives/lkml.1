Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXICLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXICLUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXICLUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:20:32 -0400
Received: from ccerelrim04.cce.hp.com ([161.114.21.25]:14038 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbXICLUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:20:31 -0400
X-Greylist: delayed 1770 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 07:20:31 EDT
From: "Bob Picco" <bob.picco@hp.com>
Date: Mon, 3 Sep 2007 06:50:57 -0400
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Daniel Walker <dwalker@mvista.com>, torvalds@linux-foundation.org,
       Bob Picco <bob.picco@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc5] driver/char/hpet.c: remove clocksourcewarning on !IA64
Message-ID: <20070903105057.GA18302@localhost>
References: <20070901155140.972420930@mvista.com> <1188679097.11196.15.camel@dhcp193.mvista.com> <617E1C2C70743745A92448908E030B2A024F3CB9@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617E1C2C70743745A92448908E030B2A024F3CB9@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.9.3.32526
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

luck wrote:	[Sun Sep 02 2007, 03:13:45AM EDT]
> > This patch eliminates the warnings when the clocksoure isn't used.
> > It also removes some other unused stuff that goes along with the
> > clocksource ..
> >
> > I don't have access to an ia64 machine, or even a compiler .. So this
> > one is untested for that. I'm hoping one of the ia64 guys can help
> > test this
> 
> Well, it does *compile* cleanly for ia64 [none of my test systems actually
> have a functional HPET ... the closest I get is one that fails the hd_nirqs
> part of the "if (!data.hd_address || !data.hd_nirqs) {" test in hpet_acpi_add].
> 
> Bob: Does this work for you?
I boot tested on the HP internal platform simulator. Should it be
necessary, I could have it boot tested later in the week on real
hardware.

bob
