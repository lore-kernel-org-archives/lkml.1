Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbXJRLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbXJRLrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbXJRLrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:47:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762001AbXJRLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:47:06 -0400
Date: Thu, 18 Oct 2007 04:47:19 -0700 (PDT)
Message-Id: <20071018.044719.115915456.davem@davemloft.net>
To: bunk@kernel.org
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ip_frag_reasm() can return uninitialized variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071018105203.GJ3778@stusta.de>
References: <20071018105203.GJ3778@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 18 Oct 2007 12:52:03 +0200

> Since commit 1706d58763c36133d7fce6cc78b1444fd40db28c ip_frag_reasm() 
> can return the value of an uninitialized variable:

I have a fix for this in my net-2.6 tree, thanks Adrian.
