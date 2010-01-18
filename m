Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102Ab0ARVeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0ARVeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067Ab0ARVeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:34:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab0ARVeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:34:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with 2.6.33-rc4-git2
Date: Mon, 18 Jan 2010 22:34:55 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
References: <20100115091053.GA5477@mac.home> <201001180136.45823.rjw@sisk.pl> <20100118083757.GA2619@mac.home>
In-Reply-To: <20100118083757.GA2619@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182234.55113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Tino Keitel wrote:
> Hi,
> 
> reverting this commit fixes WoL for me:
> 
> commit 166a0fd4c788ec7f10ca8194ec6d526afa12db75
> Author: stephen hemminger <shemminger@vyatta.com>
> Date:   Mon Dec 14 08:50:12 2009 +0000
> 
>     sky2: leave PCI config space writeable
>     
>     Since power management is done by PCI subsystem as well as driver,
>     don't toggle the bit that disables PCI register writes.
>     
>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>     Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Hmm, this is kind of interesting.

Perhaps we clear the WoL setting somewhere we shouldn't, but the
"disable PCI register writes" bit prevents this from actually happening?

Rafael
