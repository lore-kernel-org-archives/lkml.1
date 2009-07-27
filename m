Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZG0SgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZG0SgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbZG0SgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:36:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44730
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbZG0SgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:36:14 -0400
Date: Mon, 27 Jul 2009 11:36:21 -0700 (PDT)
Message-Id: <20090727.113621.207329776.davem@davemloft.net>
To: paul.moore@hp.com
Cc: julia@diku.dk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/12] net/netlabel: Correct redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907271337.30401.paul.moore@hp.com>
References: <Pine.LNX.4.64.0907271815260.2682@ask.diku.dk>
	<200907271337.30401.paul.moore@hp.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>
Date: Mon, 27 Jul 2009 13:37:29 -0400

> On Monday 27 July 2009 12:15:43 pm Julia Lawall wrote:
>> From: Julia Lawall <julia@diku.dk>
>>
>> entry was tested for NULL near the beginning of the function, followed by a
>> return, and there is no intervening modification of its value.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://www.emn.fr/x-info/coccinelle/)
 ...
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Good catch, thanks.
> 
> Acked-by: Paul Moore <paul.moore@hp.com>

Applied to net-next-2.6
