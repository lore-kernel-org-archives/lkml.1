Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0CHUtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:49:36 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:55452 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab0CHUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:49:29 -0500
X-Auth-Info: mhupzUFjHPv7lqZifRe+O94p9ubqwzWwArKgMZ4XBFM=
Message-ID: <4B95627E.1050301@grandegger.com>
Date: Mon, 08 Mar 2010 21:47:58 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: vapier@gentoo.org, urs.thuermann@volkswagen.de,
       linux-kernel@vger.kernel.org, barry.song@analog.com,
       socketcan-core@lists.berlios.de, oliver.hartkopp@volkswagen.de,
       stable-review@kernel.org, stable@kernel.org
Subject: Re: [PATCH] can: fix bfin_can build error after alloc_candev() change
References: <1268066144-26830-1-git-send-email-vapier@gentoo.org>	<4B955460.4030904@grandegger.com> <20100308.121445.71193029.davem@davemloft.net>
In-Reply-To: <20100308.121445.71193029.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Wolfgang Grandegger <wg@grandegger.com>
> Date: Mon, 08 Mar 2010 20:47:44 +0100
> 
>> Mike Frysinger wrote:
>>> From: Barry Song <barry.song@analog.com>
>>>
>>> Looks like commit a6e4bc530403 didn't include updates to drivers so the
>>> Blackfin CAN driver fails to build now.
>>>
>>> Signed-off-by: Barry Song <barry.song@analog.com>
>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> Oops, it did include updates for the drivers but at that time the bfin
>> driver was not yet mainline but somewhere in the patch pipeline.
>>
>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
> 
> Applied.
> 
> Wolfgang et al., can we add netdev to the MAINTAINERS entry
> for CAN stuff so that I don't miss stuff like this?

I see. Just sent a patch for net-2.6 adding "L: netdev@vger.kernel.org".

Wolfgang.
