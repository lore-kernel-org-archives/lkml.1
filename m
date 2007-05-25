Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbXEYUg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbXEYUg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXEYUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:36:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50061
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbXEYUgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:36:50 -0400
Date: Fri, 25 May 2007 13:36:53 -0700 (PDT)
Message-Id: <20070525.133653.57156321.davem@davemloft.net>
To: crn@netunix.com
Cc: torvalds@linux-foundation.org, mingo@elte.hu, clameter@sgi.com,
       michal.k.k.piotrowski@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, cherwin@gmail.com,
       linux-pcmcia@lists.infradead.org, robert.de.rooy@gmail.com,
       alan@redhat.com, htejun@gmail.com, sparclinux@vger.kernel.org,
       mikpe@it.uu.se, linux1394-devel@lists.sourceforge.net,
       stefanr@s5r6.in-berlin.de, krh@bitplanet.net,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl, pavel@ucw.cz,
       marcus@better.se, arvidjaar@mail.ru,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <46572507.6010800@netunix.com>
References: <4656CE39.8050800@netunix.com>
	<alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
	<46572507.6010800@netunix.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Newport <crn@netunix.com>
Date: Fri, 25 May 2007 19:03:51 +0100

> Not really a Solaris feature. This is a feature of the  Openboot  PROM
> which is also used by several other vendors.
> The Openboot PROM knows how to write to disk. The same should
> apply on Apple hardware and others which use the openboot
> convention.

This is totally unusable even if it weren't stupid, and as
someone who loves OpenBoot I think it's very stupid.

The reason it's unusable is that PowerPC already and sparc64 soon (in
order to support LDOMs) totally drops the OBP firmware very soon after
early kernel boot.  We pull in the device tree and then say "see ya"
to openboot.

PowerPC does it because sharing the address space with openboot is
next to impossible on that cpu, sparc64 will need to do it because
dynamic-reconfiguration of cpus in an LDOM is too hard to do with
openboot there.
