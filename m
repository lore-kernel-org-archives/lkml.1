Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0CANSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:18:08 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33350 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab0CANSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:18:07 -0500
Date: Mon, 1 Mar 2010 15:18:01 +0200
From: Jouni Malinen <j@w1.fi>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Problem with bridges and wireless NIC's
Message-ID: <20100301131801.GA3449@jm.kir.nu>
References: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
 <20100301075953.GA32038@jm.kir.nu>
 <9c30dffe1003010012l5b3a912fma5655e630b83ce9f@mail.gmail.com>
 <20100301105329.GA2684@jm.kir.nu>
 <9c30dffe1003010340r20a179c6hd2d5e7eeeba8d106@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c30dffe1003010340r20a179c6hd2d5e7eeeba8d106@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 12:40:14PM +0100, Bjarke Istrup Pedersen wrote:
> Okay, so the best thing to do, is to advise people to reverse the
> patch if the need 0.6.x, or use 0.7.x - right?

I don't think I would recommend people to reverse the commit that made
kernel reject invalid wlan0 mode in the bridge in general. It should be
possible to reorder network configuration to work with it and if really
not, reverting that change is reasonable only for a device that works as
an AP and uses bridging. Alternatively, whoever needs hostapd 0.6.x for
whatever reason could obviously also backport the hostapd patch for
bridge setup.

-- 
Jouni Malinen                                            PGP id EFC895FA
