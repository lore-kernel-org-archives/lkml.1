Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZBRBm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZBRBm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbZBRBlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:41:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47224
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756230AbZBRBl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:41:27 -0500
Date: Tue, 17 Feb 2009 17:41:12 -0800 (PST)
Message-Id: <20090217.174112.80573704.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/43] drivers/net/tokenring: fix sparse warning:
 symbol shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214426.24377.61106.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214426.24377.61106.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:44:44 +0100

> Impact: Remove redundant variables.
> 
> Fix this sparse warnings:
>   drivers/net/tokenring/lanstreamer.c:619:21: warning: symbol 'i' shadows an earlier one
>   drivers/net/tokenring/lanstreamer.c:589:13: originally declared here
>   drivers/net/tokenring/madgemc.c:695:34: warning: symbol 'tp' shadows an earlier one
>   drivers/net/tokenring/madgemc.c:689:26: originally declared here
>   drivers/net/tokenring/olympic.c:702:21: warning: symbol 'i' shadows an earlier one
>   drivers/net/tokenring/olympic.c:440:13: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
