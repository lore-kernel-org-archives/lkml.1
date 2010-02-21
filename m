Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab0BUXCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:02:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50077
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0BUXCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:02:54 -0500
Date: Sun, 21 Feb 2010 15:03:11 -0800 (PST)
Message-Id: <20100221.150311.193707249.davem@davemloft.net>
To: lars.eggert@nokia.com
Cc: zimmermann@nets.rwth-aachen.de, pavel@ucw.cz, apetlund@simula.no,
       netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi,
       eric.dumazet@gmail.com, Arnd.Hannemann@nets.rwth-aachen.de,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       william.allen.simpson@gmail.com, damian@tvk.rwth-aachen.de,
       ebiederm@xmission.com
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com>
References: <20100221102102.GB1311@ucw.cz>
	<D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
	<2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Eggert <lars.eggert@nokia.com>
Date: Sun, 21 Feb 2010 22:04:46 +0200

> Agree with Alexander. It is not at all clear to me that these
> changes are safe for non-exerimental use in the wider Internet.

It's off by default and we provide all sorts of experimental
congestion control algorithms which can cause just as much
if not more trouble than these thin-stream bits.

There is no problem integrating these changes.
