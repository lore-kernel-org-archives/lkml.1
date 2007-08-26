Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXHZR3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXHZR3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXHZR3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:29:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22108 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbXHZR2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:28:48 -0400
Date: Sun, 26 Aug 2007 10:27:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       rt2400-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc3-mm1 -- drivers/net/wireless/rt2x00mac.c:65: error:
 too many arguments to function =?UTF-8?Q?=E2=80=98ieee80211=5Frts=5Fget?=
 =?UTF-8?Q?=E2=80=99?=
Message-Id: <20070826102751.014bb0be.randy.dunlap@oracle.com>
In-Reply-To: <a44ae5cd0708260954o15c1a8dasad736c352d2ed170@mail.gmail.com>
References: <a44ae5cd0708260954o15c1a8dasad736c352d2ed170@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Aug 2007 12:54:33 -0400 Miles Lane wrote:

>   CC [M]  drivers/net/wireless/rt2x00mac.o
> drivers/net/wireless/rt2x00mac.c: In function 'rt2x00mac_tx_rts_cts':
> drivers/net/wireless/rt2x00mac.c:61: warning: passing argument 2 of
> 'ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing argument 3 of
> 'ieee80211_ctstoself_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing argument 4 of
> 'ieee80211_ctstoself_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:61: warning: passing argument 5 of
> 'ieee80211_ctstoself_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:61: error: too many arguments to
> function 'ieee80211_ctstoself_get'
> drivers/net/wireless/rt2x00mac.c:65: warning: passing argument 2 of
> 'ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing argument 3 of
> 'ieee80211_rts_get' makes integer from pointer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing argument 4 of
> 'ieee80211_rts_get' makes pointer from integer without a cast
> drivers/net/wireless/rt2x00mac.c:65: warning: passing argument 5 of
> 'ieee80211_rts_get' from incompatible pointer type
> drivers/net/wireless/rt2x00mac.c:65: error: too many arguments to
> function 'ieee80211_rts_get'
> make[3]: *** [drivers/net/wireless/rt2x00mac.o] Error 1
> 
> -------------

Hi Miles,

Please see this thread:
http://lkml.org/lkml/2007/8/22/389

IOW, wireless in rc3-mm1 is known busted.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
