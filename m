Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZBRDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZBRDvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZBRDuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:50:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZBRDuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:50:07 -0500
Date: Tue, 17 Feb 2009 19:49:51 -0800 (PST)
Message-Id: <20090217.194951.04719813.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, jjschlst@gmail.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 31/43 v2] drivers/net/tokenring: fix sparse warning:
 cast truncates bits from const value
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090215121201.26072.42971.stgit@vmbox.hanneseder.net>
References: <154e089b0902150347o4e06683dy1c9c02dc2564ea4f@mail.gmail.com>
	<20090215121201.26072.42971.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sun, 15 Feb 2009 13:13:01 +0100

> Impact: Remove the write-only field 'current_ring_status' completely.
> 
> Fix this sparse warnings:
>   drivers/net/tokenring/smctr.c:4410:52: warning: cast truncates bits from constant value (100 becomes 0)
>   drivers/net/tokenring/smctr.c:4415:52: warning: cast truncates bits from constant value (400 becomes 0)
>   drivers/net/tokenring/smctr.c:4420:52: warning: cast truncates bits from constant value (800 becomes 0)
>   drivers/net/tokenring/smctr.c:4425:52: warning: cast truncates bits from constant value (1000 becomes 0)
>   drivers/net/tokenring/smctr.c:4430:52: warning: cast truncates bits from constant value (2000 becomes 0)
>   drivers/net/tokenring/smctr.c:4435:52: warning: cast truncates bits from constant value (4000 becomes 0)
>   drivers/net/tokenring/smctr.c:4440:52: warning: cast truncates bits from constant value (8000 becomes 0)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
