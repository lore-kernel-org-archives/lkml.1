Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbXJZNoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbXJZNoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJZNoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:44:00 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:56563 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXJZNn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:43:59 -0400
Message-ID: <4721EF03.1080605@hp.com>
Date: Fri, 26 Oct 2007 09:43:31 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jens.axboe@oracle.com
Subject: Re: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
References: <4720F775.8030702@hp.com> <20071025.184654.191409554.davem@davemloft.net>
In-Reply-To: <20071025.184654.191409554.davem@davemloft.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Vlad Yasevich <vladislav.yasevich@hp.com>
> Date: Thu, 25 Oct 2007 16:07:17 -0400
> 
>> Crypto now uses SG helper functions.  Fix hmac_digest to use those
>> functions correctly and fix the oops associated with it.
>>
>> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> 
> Since I keep hitting this when I try to test IPSEC on my systems
> I'm going to apply this to my net-2.6 tree.
> 
> Herbert, I hope you don't mind :-)
> 

Got reported to me because SCTP kept breaking.  Wasn't sure which
way to send it.

As long as it's somewhere, I am happy.

Thanks
-vlad
