Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036Ab0AWMVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0AWMVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117Ab0AWMV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:21:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35984 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082Ab0AWMVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:21:25 -0500
Date: Sat, 23 Jan 2010 12:23:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>,
       linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Subject: Re: [PATCH 30/31] CAPI: Remove experimental tag from middleware
 feature
Message-ID: <20100123122327.7d2622f4@lxorguk.ukuu.org.uk>
In-Reply-To: <9dd553d458def04edc7790f0320ffdf1f8909aa5.1264201408.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
	<9dd553d458def04edc7790f0320ffdf1f8909aa5.1264201408.git.jan.kiszka@web.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 14:12:41 +0100
Jan Kiszka <jan.kiszka@web.de> wrote:

> Despite all its bugs, the middleware support of our CAPI stack was
> already in use for many, many moons. And after going through its code,
> fixing all issues I found, I feel it deserves to officially become a
> non-experimental feature.

Slightly NAK this - I'm really glad to see the work getting done, but
until it uses krefs properly for the tty references I'd say it is
experimental still.

I'd like to help you sort out the tty krefs stuff, using tty_port and so
on and get that wart fixed too.

Alan
