Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXLTLWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXLTLWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXLTLWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:22:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47471
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754402AbXLTLW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:22:29 -0500
Date: Thu, 20 Dec 2007 03:22:28 -0800 (PST)
Message-Id: <20071220.032228.186653113.davem@davemloft.net>
To: Robert.Olsson@data.slu.se
Cc: gallatin@myri.com, joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <18282.15185.592112.550961@robur.slu.se>
References: <47601A73.5010804@myri.com>
	<20071212.093819.205755031.davem@davemloft.net>
	<18282.15185.592112.550961@robur.slu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Olsson <Robert.Olsson@data.slu.se>
Date: Thu, 20 Dec 2007 10:52:17 +0100

>  Yes but the reason was not to wait for all pending polls to
>  complete so a server/router could be rebooted even under high-
>  load and DOS. We've experienced some nasty problems with this.

I know, see the rest of the thread where I agree that
we need to deal with this somehow.

The device is marked down first, and somehow we need to
tip off of that to break out of the NAPI loop.  This
"how" is what hasn't been resolved yet.
