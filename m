Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbYDPU3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbYDPU3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYDPU3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:29:23 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4521 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYDPU3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:29:22 -0400
Date: Wed, 16 Apr 2008 15:58:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Message-ID: <20080416195822.GA25066@tuxdriver.com>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080416183705.GA16123@tuxdriver.com> <200804162126.43771.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804162126.43771.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 09:26:43PM +0200, Ivo van Doorn wrote:
> On Wednesday 16 April 2008, John W. Linville wrote:

> > If they are coming to me, please collect Ivo's ACKs and resend them
> > to linux-wireless@vger.kernel.org with me CC'ed as well.
> 
> I am going to setup a rfkill git tree from where rfkill can be managed,
> but I still had to look into the correct git tree to branch from.
> 
> We should sort out how the rfkill patch flow should go,
> directly into net-2.6 or to wireless-2.6/wireless-testing
> Although rfkill is a wireless tool, one could argue that linux-wireless
> is mostly aimed at the 802.11 protocol, whereas rfkill applies to
> irda and bluetooth as well.

I suppose you could manage it as a separate tree.  Before this round of
patches, that would have seemed like overkill. :-)  My only argument
would be that there are probably more users of rfkill in the wireless
(i.e. wireless LAN) trees than in the Bluetooth, UWB, or WiMAX trees.
But honestly, it is up to you and Dave.  I'm happy to take the patches
in my trees or you guys can arrange something else.

Just let me know if you want me to merge them.  Otherwise, I'll drop
them from my queue.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
