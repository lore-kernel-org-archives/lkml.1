Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXLNNG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXLNNG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXLNNGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:06:49 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51651 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbXLNNGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:06:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 14:04:23 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Ray Lee <ray-lk@madrabbit.org>,
       bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, John Linville <linville@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <200712141331.59410.mb@bu3sch.de> <1197637194.7549.10.camel@odie.local>
In-Reply-To: <1197637194.7549.10.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712141404.24275.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 13:59:54 Simon Holm Thøgersen wrote:
> > This user did get the following messages in dmesg:
> > 
> > b43err(dev->wl, "Firmware file \"%s\" not found "
> >        "or load failed.\n", path);
> 
> So the question seems to be why b43 needs version 4, when b43legacy and
> bcm43x uses version 3?

That's really a question, right?

Well. linux-2.4 doesn't work with the linux-2.6 modutils.
Windows Vista doesn't work with Windows 98 device drivers.
That leads to this assumption:
b43 doesn't work with version 3 firmware but needs version 4.

Newer drivers supporting newer hardware need newer firmware.

-- 
Greetings Michael.
