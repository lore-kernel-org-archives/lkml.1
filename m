Return-Path: <linux-kernel-owner+w=401wt.eu-S937948AbXHGWC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937948AbXHGWC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966616AbXHGVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:37:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55800 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966596AbXHGVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:37:08 -0400
Date: Tue, 7 Aug 2007 23:37:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [2.6.22.2 review 09/84] Fix rfkill IRQ flags.
In-Reply-To: <20070807204308.GJ23028@kroah.com>
Message-ID: <Pine.LNX.4.64.0708072336030.26397@fbirervta.pbzchgretzou.qr>
References: <20070807204034.882009319@mini.kroah.org> <20070807204308.GJ23028@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7 2007 13:43, Greg KH wrote:
>
>added this 64-bit bug:
>
>        ....
>	unsigned int flags;
>
> 	spin_lock_irqsave(&task->lock, flags);
>        ....
>
>irq 'flags' must be unsigned long, not unsigned int. The -rt tree has
>strict checks about this on 64-bit so this triggered a build failure.

Since the check is a compile-time one, would not it be good to add
it to the regular linux tree too?


	Jan
-- 
