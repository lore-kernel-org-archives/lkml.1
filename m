Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYIUTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYIUTew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYIUTek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:34:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54213 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYIUTej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:34:39 -0400
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
	restart.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com, davem@davemloft.net
In-Reply-To: <20080921172316.GA6306@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
Content-Type: text/plain
Date: Sun, 21 Sep 2008 21:35:31 +0200
Message-Id: <1222025731.6782.117.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

> Following bug exists in the ipw2100 driver/firmware for years and Intel
> folks never responded to zillions bugzilla entries and forum notices in
> the internet with some patch or firmware update (although did request
> dmesg and debug info, and received them).
> 
> ipw2100: Fatal interrupt. Scheduling firmware restart.
> 
> I believe it is a firmware bug because after driver is unloaded and
> loaded back again wireless adapter usually starts working (for small
> amount of time though). My conspiracy feeling can suggest, that it may
> be kind of a force to buy a new one, or trivial error in the firmware,
> when it writes to the same place in the flash and essentially given cell
> became dead or whatever else.

I don't know if it is for this bug or a different one, but Matthew
Garrett seem to have some pending patches. At least that is what he told
me at PlumbersConf. Lets see if these patches do help. And please follow
up with Arjan's suggestion and put a WARN_ON in the upstream code
instead of waving CONFIG_BROKEN around.

Regards

Marcel


