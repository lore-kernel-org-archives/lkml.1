Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0CHUOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:14:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36390
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755599Ab0CHUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:14:26 -0500
Date: Mon, 08 Mar 2010 12:14:45 -0800 (PST)
Message-Id: <20100308.121445.71193029.davem@davemloft.net>
To: wg@grandegger.com
Cc: vapier@gentoo.org, socketcan-core@lists.berlios.de,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       linux-kernel@vger.kernel.org, barry.song@analog.com, stable@kernel.org,
       stable-review@kernel.org
Subject: Re: [PATCH] can: fix bfin_can build error after alloc_candev()
 change
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B955460.4030904@grandegger.com>
References: <1268066144-26830-1-git-send-email-vapier@gentoo.org>
	<4B955460.4030904@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Mon, 08 Mar 2010 20:47:44 +0100

> Mike Frysinger wrote:
>> From: Barry Song <barry.song@analog.com>
>> 
>> Looks like commit a6e4bc530403 didn't include updates to drivers so the
>> Blackfin CAN driver fails to build now.
>> 
>> Signed-off-by: Barry Song <barry.song@analog.com>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Oops, it did include updates for the drivers but at that time the bfin
> driver was not yet mainline but somewhere in the patch pipeline.
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Applied.

Wolfgang et al., can we add netdev to the MAINTAINERS entry
for CAN stuff so that I don't miss stuff like this?
