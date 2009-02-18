Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZBRDhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZBRDhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZBRDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:35:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59011
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbZBRDfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:35:45 -0500
Date: Tue, 17 Feb 2009 19:35:29 -0800 (PST)
Message-Id: <20090217.193529.238038987.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 37/43] drivers/net/wireless: fix sparse warning:
 context imbalance
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214833.24377.6182.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214833.24377.6182.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:48:44 +0100

> Impact: Attribute function with __acquires(...) resp. __releases(...).
> 
> Fix this sparse warnings:
>   drivers/net/wireless/strip.c:955:21: warning: context imbalance in 'strip_seq_start' - wrong count at exit
>   drivers/net/wireless/strip.c:975:13: warning: context imbalance in 'strip_seq_stop' - unexpected unlock
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
