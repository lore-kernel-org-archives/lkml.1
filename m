Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZBRB2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZBRB2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZBRB1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755877AbZBRB1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:10 -0500
Date: Tue, 17 Feb 2009 17:26:54 -0800 (PST)
Message-Id: <20090217.172654.50571162.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/43] drivers/net/atlx: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211508.23489.57841.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211508.23489.57841.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:15:17 +0100

> Impact: While being at it: statics do not need to be initialized with 0.
> 
> Fix this sparse warnings:
>   drivers/net/atlx/atl1.c:109:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atlx/atl2.c:2870:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atlx/atl2.c:2880:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atlx/atl2.c:2894:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atlx/atl2.c:2904:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atlx/atl2.c:2913:1: warning: incorrect type in initializer (different signedness)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
