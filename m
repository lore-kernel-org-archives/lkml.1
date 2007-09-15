Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXIOSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXIOSj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXIOSjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:39:22 -0400
Received: from tag.witbe.net ([81.88.96.48]:58126 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXIOSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:39:21 -0400
Date: Sat, 15 Sep 2007 18:39:17 +0000
From: Paul Rolland <rol@as2917.net>
To: "Rob Hussey" <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: 2.6.23-rc6 : crash with RTL8187 USB
Message-ID: <20070915183917.7b72f754@tux.DEF.witbe.net>
In-Reply-To: <6b8cef970709150921s48488096wa8089d8d9f5d28bf@mail.gmail.com>
References: <20070915131656.4cddab33@tux.DEF.witbe.net>
	<6b8cef970709150921s48488096wa8089d8d9f5d28bf@mail.gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Sat, 15 Sep 2007 12:21:39 -0400
"Rob Hussey" <robjhussey@gmail.com> wrote:

> On 9/15/07, ポール・ロラン Paul Rolland <rol@witbe.net> wrote:
> > Hello,
> >
> I had this problem as well. It has to do with mac80211, cfg80211 and
> the rate control algorithm not initializing early enough in the boot
> process. These two patches should fix it:
> 
> [PATCH] mac80211: fix initialisation when built-in
> http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation
> 
> [PATCH] cfg80211: fix initialisation if built-in
> http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation

Yes, they do !
Thanks very much,

Regards,
Paul


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
