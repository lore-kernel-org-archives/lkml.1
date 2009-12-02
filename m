Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZLBVyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZLBVyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZLBVyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:54:37 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:31694 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755714AbZLBVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:54:36 -0500
Date: Thu, 3 Dec 2009 00:54:42 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: felipe.balbi@nokia.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091202215442.GA30658@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <20091202173321.GA23738@nokia.com>
 <6ed0b2680912021234x6b5e6058p6d50d5cd20ecf019@mail.gmail.com>
 <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:29:10PM +0200, Grazvydas Ignotas wrote:
[...]
> From what I saw in other drivers they are setup to start charging
> automatically as soon as they see VBUS.

Yes. I see nothing wrong here.

> > How are you differing between those currently?
> 
> Not handled at all at the moment (uses BCI defaults).
[...]
> Agree about USB userspace switch though..

Yes, so far we don't have any writable properties in power supply
class, though the feature is in demand by various drivers.
Somebody should step up and implement it. ;-)

But for the start, I like this driver the way it is.

As for the default USB VBUS current value, it could be Kconfig
option (something alike to USB_GADGET_VBUS_DRAW) and/or module
parameter, or hw default, or hardcoded for now. Either will
work.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
