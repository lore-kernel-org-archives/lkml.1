Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYC1Avw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYC1Avw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYC1Avl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:51:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50229
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbYC1Avk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:51:40 -0400
Date: Thu, 27 Mar 2008 17:51:40 -0700 (PDT)
Message-Id: <20080327.175140.93155828.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:02 +0200

> Allyesconfig (v2.6.24-mm1):
> 
> -23668  392 funcs, 104 +, 23772 -, diff: -23668 --- dev_alloc_skb
> 
> Without many debug CONFIGs (v2.6.25-rc2-mm1):
> 
> -12178  382 funcs, 157 +, 12335 -, diff: -12178 --- dev_alloc_skb
> dev_alloc_skb                 |  +37
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
