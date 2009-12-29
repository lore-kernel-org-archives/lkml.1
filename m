Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbZL2UCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbZL2UCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZL2UCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:02:19 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:53080 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZL2UCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:02:18 -0500
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for
 Nokia N800 and N810
From: Felipe Balbi <me@felipebalbi.com>
Reply-To: me@felipebalbi.com
To: Tony Lindgren <tony@atomide.com>
Cc: Luke-Jr <luke@dashjr.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <20091229192407.GA3512@atomide.com>
References: <200912290152.16357.luke@dashjr.org>
	 <20091229192407.GA3512@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 21:35:49 +0200
Message-ID: <1262115349.28789.79.camel@gandalf>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-12-29 at 11:24 -0800, Tony Lindgren wrote:
> Great. The comment from Russell earlier was that we should be now using
> clkdev to do things like this and get rid of the _set_clock functions.
> In musb_core.c are already using the clk directly if set_clock is NULL.
> 
> Can you try the patch below? If it works, just merge it into your
> patch.

Yes, let's do like Tony suggested. I'm removing the old set_clock stuff
completely, patches are available at my git tree, here are the links:

http://gitorious.org/usb/usb/commit/ca415cf06a4843e93041fe73f7f1867e066b48a3
http://gitorious.org/usb/usb/commit/013f8457a1ba0dd3f36811f647b0fe904128292e
http://gitorious.org/usb/usb/commit/e2ecae4c5b01415dbbf714c7217178c31a9a5dd1
http://gitorious.org/usb/usb/commit/874afb373ea75ff0a3a360802a53357affa27df0
http://gitorious.org/usb/usb/commit/6d47fc9858c17faea8a454e147839c878737a0f1
http://gitorious.org/usb/usb/commit/62b8d94df7739cb60bae0369b8265e588f518841
http://gitorious.org/usb/usb/commit/e06629acd44936fe87d34d188c8dfb54abd7915c

Tony, if you want I can send you a pull request will all the patches I
have prepared on top of your tree. There's only one dependence which I
can ship in the same pull request.

Sames goes to Kevin regarding davinci tree. I just have to subscribe in
order to be able to send the patches there.

-- 
balbi

