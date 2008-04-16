Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYDPUgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYDPUgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYDPUgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:36:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYDPUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Do9qC9yEpDy9keakI2dG4FcUpc6p0F09mkRl6nuPkVPib1nrNbGcBuOfDRPX/96vsr7Z60prnWMA+xWU01hHyQpjJBQikPgoXMDDlCn1kiUGnkNnGfcnhBOfNMbKOaone0ZkVXddry48W7oNFu8IO1PN//OWNCtCXJae3/d6VcU=
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Date: Wed, 16 Apr 2008 22:40:38 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804162126.43771.IvDoorn@gmail.com> <20080416195822.GA25066@tuxdriver.com>
In-Reply-To: <20080416195822.GA25066@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804162240.38704.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, John W. Linville wrote:
> On Wed, Apr 16, 2008 at 09:26:43PM +0200, Ivo van Doorn wrote:
> > On Wednesday 16 April 2008, John W. Linville wrote:
> 
> > > If they are coming to me, please collect Ivo's ACKs and resend them
> > > to linux-wireless@vger.kernel.org with me CC'ed as well.
> > 
> > I am going to setup a rfkill git tree from where rfkill can be managed,
> > but I still had to look into the correct git tree to branch from.
> > 
> > We should sort out how the rfkill patch flow should go,
> > directly into net-2.6 or to wireless-2.6/wireless-testing
> > Although rfkill is a wireless tool, one could argue that linux-wireless
> > is mostly aimed at the 802.11 protocol, whereas rfkill applies to
> > irda and bluetooth as well.
> 
> I suppose you could manage it as a separate tree.  Before this round of
> patches, that would have seemed like overkill. :-)  My only argument
> would be that there are probably more users of rfkill in the wireless
> (i.e. wireless LAN) trees than in the Bluetooth, UWB, or WiMAX trees.
> But honestly, it is up to you and Dave.  I'm happy to take the patches
> in my trees or you guys can arrange something else.

Dave, do you want the rfkill patches directly, or should they go through
the wireless tree first?

> Just let me know if you want me to merge them.  Otherwise, I'll drop
> them from my queue.

Well the patches from Henrique shouldn't be applied yet,
since he is reworking several of those patches.

Ivo
