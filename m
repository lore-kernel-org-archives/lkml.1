Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZBRDgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZBRDgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZBRDfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:35:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59005
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbZBRDff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:35:35 -0500
Date: Tue, 17 Feb 2009 19:35:19 -0800 (PST)
Message-Id: <20090217.193519.162889859.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/43] drivers/net/wan: fix warning: format not a
 string literal and no ...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214755.24377.57742.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214755.24377.57742.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:48:07 +0100

> Impact: Use 'static const char[]' instead of 'static char[]'.
> 
> Fix this compilation warnings:
>   drivers/net/wan/lapbether.c: In function 'lapbeth_init_driver':
>   drivers/net/wan/lapbether.c:441: warning: format not a string literal and no format arguments
>   drivers/net/wan/z85230.c: In function 'z85230_init_driver':
>   drivers/net/wan/z85230.c:1782: warning: format not a string literal and no format arguments
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
