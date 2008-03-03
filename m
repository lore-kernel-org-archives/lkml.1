Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbYCCUMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbYCCUMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYCCULt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:11:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54085
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754165AbYCCULs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:11:48 -0500
Date: Mon, 03 Mar 2008 12:11:29 -0800 (PST)
Message-Id: <20080303.121129.183509475.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: guichaz@gmail.com, akpm@linux-foundation.org, ray-lk@madrabbit.org,
       cw@f00f.org, giangiacomo_mariotti@yahoo.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6] [TCP]: Must count fack_count also when
 skipping 
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803031541230.28251@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0803031025210.18640@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0803031525390.27064@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0803031541230.28251@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Mon, 3 Mar 2008 15:53:12 +0200 (EET)

> [PATCH net-2.6] [TCP]: Must count fack_count also when skipping
> 
> It makes fackets_out to grow too slowly compared with the
> real write queue.
> 
> This shouldn't cause those BUG_TRAP(packets <= tp->packets_out)
> to trigger but how knows how such inconsistent fackets_out
> affects here and there around TCP when everything is nowadays
> assuming accurate fackets_out. So lets see if this silences
> them all.
> 
> Reported by Guillaume Chazarain <guichaz@gmail.com>.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied, thanks Ilpo.
