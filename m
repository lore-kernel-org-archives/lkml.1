Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZCSRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZCSRv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZCSRvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:51:47 -0400
Received: from bu3sch.de ([62.75.166.246]:36104 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZCSRvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:51:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for March 19 (wireless/p54)
Date: Thu, 19 Mar 2009 18:50:17 +0100
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <49C280BE.8090106@oracle.com>
In-Reply-To: <49C280BE.8090106@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903191850.17825.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 18:28:30 Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090318:
> 
> 
> ERROR: "led_classdev_register" [drivers/net/wireless/p54/p54common.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/net/wireless/p54/p54common.ko] undefined!
> 
> One possible option (fix) is to have CONFIG_MAC80211_LEDS also select
> LEDS_CLASS (that would build the missing functions).

Does p54 select CONFIG_MAC80211_LEDS? If that's the case, I think it should
probably do it the other way around. p54 should build its LED code if CONFIG_MAC80211_LEDS
is available. Otherwise it should not.

This way you don't enter the SELECT dependency hell and still have automagic configuration.

Take a look at b43 for an example.

-- 
Greetings, Michael.
