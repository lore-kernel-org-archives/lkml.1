Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZKQWIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZKQWIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZKQWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:08:52 -0500
Received: from senator.holtmann.net ([87.106.208.187]:58331 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZKQWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:08:51 -0500
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
 why?
From: Marcel Holtmann <marcel@holtmann.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Michael Renzmann <mrenzmann@madwifi-project.org>,
       madwifi-devel@lists.sourceforge.net,
       madwifi-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20091117140534.GD27743@tuxdriver.com>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	 <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	 <20091117140534.GD27743@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 23:08:51 +0100
Message-ID: <1258495731.2003.44.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> > If a few developers still exist who are committed to helping maintain
> > madwifi until ath5k gets feature-parred the easiest solution now
> > (since the HAL is open) is to just throw it into staging and hopefully
> > that'll attract more developers to help keep it up to date with actual
> > current kernels.
> 
> For the record, I would be generally opposed to adding madwifi to
> drivers/staging.  We already have enough trouble with duplication of
> hardware support between drivers/staging and drivers/net/wireless.
> 
> If madwifi has features that people need/want and that ath5k/mac80211
> still lacks, lets talk about how to get them (or reasonabe replacements
> for them) into the mainline kernel.  I'm sure some ideas will meet
> some resistance, but if someone is motivated to continue pursuing
> maintenance of madwifi than they should be motivated enough to at
> least try to convince the rest of us why those features are worth
> having in net/wireless, net/mac80211, and/or drivers/net/wireless.
> Even if the solution is some quirky thing that "normal" people will
> ignore, it is bound to be better to have mainline support than to
> continue working out-of-tree.

I 100% agree with you. The MadWifi driver should NOT be included into
the staging tree. We have an upstream driver for this hardware and if
people are not happy with it, then they should start fixing or extending
it. A second driver for the same hardware just causes confusion.

Regards

Marcel


