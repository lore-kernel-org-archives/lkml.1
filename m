Return-Path: <linux-kernel-owner+w=401wt.eu-S935974AbYEUDyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935974AbYEUDyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935344AbYEUDmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:42:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38045 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935363AbYEUDmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:42:18 -0400
X-Sasl-enc: pgHPmbTEs1ihd9+RYNfCbVeIfoIzpbrkGDsy17MJSF+3 1211341335
Date: Wed, 21 May 2008 00:42:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Message-ID: <20080521034213.GE26427@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805201208.53740.IvDoorn@gmail.com> <20080521011257.GA26427@khazad-dum.debian.net> <200805202035.20529.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805202035.20529.inaky@linux.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Inaky Perez-Gonzalez wrote:
> On Tuesday 20 May 2008, Henrique de Moraes Holschuh wrote:
> > On Tue, 20 May 2008, Ivo van Doorn wrote:
> > > On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> > > > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > > > as most devices really want to use KEY_WLAN for WWAN control (in a cycle of
> > > > none, WLAN, WWAN, WLAN+WWAN) and need no specific keycode added.
> > > >
> > > > Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> 
> BTW, I just realized this was mistakenly put in your initial patch; 
> you signed off for me and also added me to the CC :)

Urk, that's embarassing.  Sorry about it!  Fixed.

> > Stuff like "WiMax", "802.1a", "EDGE", "GRPS", "802.1bg" would be the
> > type, and class would be "WLAN", "WWAN", etc.
> > 
> > We would only deal with classes on rfkill-input.  Anything else more
> > specific should be done in userspace instead, disabling rfkill-input.
> 
> How would this apply to the case where I want to use the HW key to switch
> one off and turn the other one off (say I have both a WiMAX and EDGE
> cards in my machine); how could we do it to distinguish which key is which?
> I might be missing something.

I don't understand.  Switch one off and turn the other one off?  Isn't
that the same thing?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
