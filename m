Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYC1AoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYC1AoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYC1Ant
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:43:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39585
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYC1Ant convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:43:49 -0400
Date: Thu, 27 Mar 2008 17:43:48 -0700 (PDT)
Message-Id: <20080327.174348.05360095.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:00 +0200

> Allyesconfig (v2.6.24-mm1):
> 
> ~500 files changed
> ...
>  869 funcs, 198 +, 111003 -, diff: -110805 --- skb_put
>   skb_put                       | +104
> 
> Without number of debug related CONFIGs (v2.6.25-rc2-mm1):
> 
> -60744  855 funcs, 861 +, 61605 -, diff: -60744 --- skb_put
>   skb_put                       |  +57
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
