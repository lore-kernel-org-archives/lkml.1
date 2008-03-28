Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYC1AwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYC1AwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYC1AwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:52:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50234
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbYC1AwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:52:12 -0400
Date: Thu, 27 Mar 2008 17:52:12 -0700 (PDT)
Message-Id: <20080327.175212.119805454.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: ilpo.jarvinen@helsinki.fi, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803280036.59311.vda.linux@googlemail.com>
References: <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<200803280036.59311.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 28 Mar 2008 00:36:59 +0100

> Can you add a comment which explains the intent?
> 
> +struct sk_buff *dev_alloc_skb(unsigned int length)
> +{
> +       /* There is more code here than it seems:
> +        * __dev_alloc_skb is an inline */
> +	return __dev_alloc_skb(length, GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL(dev_alloc_skb);

I've applied his patch already, if you want this comment
please submit the patch to add it and also please use
the correct formatting of the comment.
