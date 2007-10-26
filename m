Return-Path: <linux-kernel-owner+w=401wt.eu-S1762455AbXJZBrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455AbXJZBrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXJZBqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:46:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48243
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbXJZBqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:46:54 -0400
Date: Thu, 25 Oct 2007 18:46:54 -0700 (PDT)
Message-Id: <20071025.184654.191409554.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jens.axboe@oracle.com
Subject: Re: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4720F775.8030702@hp.com>
References: <4720F775.8030702@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 25 Oct 2007 16:07:17 -0400

> Crypto now uses SG helper functions.  Fix hmac_digest to use those
> functions correctly and fix the oops associated with it.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Since I keep hitting this when I try to test IPSEC on my systems
I'm going to apply this to my net-2.6 tree.

Herbert, I hope you don't mind :-)
