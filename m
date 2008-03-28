Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYC1AxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYC1AxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYC1Awt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:52:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50242
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbYC1Aws convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:52:48 -0400
Date: Thu, 27 Mar 2008 17:52:48 -0700 (PDT)
Message-Id: <20080327.175248.223135849.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 4/7] [NET]: uninline skb_push, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:03 +0200

> Allyesconfig (v2.6.24-mm1):
> 
> -21593  356 funcs, 2418 +, 24011 -, diff: -21593 --- skb_push
> 
> Without many debug related CONFIGs (v2.6.25-rc2-mm1):
> 
> -13890  341 funcs, 189 +, 14079 -, diff: -13890 --- skb_push
> skb_push                      |  +46
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Applied.
