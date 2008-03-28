Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYC1Ay0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYC1Ay0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYC1AyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:54:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbYC1AyJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:54:09 -0400
Date: Thu, 27 Mar 2008 17:54:08 -0700 (PDT)
Message-Id: <20080327.175408.69286698.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 6/7] [NET]: uninline skb_trim, de-bloats
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:05 +0200

> Allyesconfig (v2.6.24-mm1):
> -10976  209 funcs, 123 +, 11099 -, diff: -10976 --- skb_trim
> 
> Without number of debug related CONFIGs (v2.6.25-rc2-mm1):
> -7360  192 funcs, 131 +, 7491 -, diff: -7360 --- skb_trim
> skb_trim                      |  +42
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
