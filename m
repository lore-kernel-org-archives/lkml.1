Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYEUDx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYEUDx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934611AbYEUDf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:35:59 -0400
Received: from mga12.intel.com ([143.182.124.36]:27671 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934599AbYEUDf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,518,1204531200"; 
   d="scan'208";a="249881580"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Date: Tue, 20 May 2008 20:35:19 -0700
User-Agent: KMail/1.9.9
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805201208.53740.IvDoorn@gmail.com> <20080521011257.GA26427@khazad-dum.debian.net>
In-Reply-To: <20080521011257.GA26427@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805202035.20529.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 20 May 2008, Ivo van Doorn wrote:
> > On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:

> > > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > > as most devices really want to use KEY_WLAN for WWAN control (in a cycle of
> > > none, WLAN, WWAN, WLAN+WWAN) and need no specific keycode added.
> > >
> > > Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

BTW, I just realized this was mistakenly put in your initial patch; 
you signed off for me and also added me to the CC :)
 
> Stuff like "WiMax", "802.1a", "EDGE", "GRPS", "802.1bg" would be the
> type, and class would be "WLAN", "WWAN", etc.
> 
> We would only deal with classes on rfkill-input.  Anything else more
> specific should be done in userspace instead, disabling rfkill-input.

How would this apply to the case where I want to use the HW key to switch
one off and turn the other one off (say I have both a WiMAX and EDGE
cards in my machine); how could we do it to distinguish which key is which?
I might be missing something.

-- 
Inaky
