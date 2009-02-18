Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZBRDgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZBRDgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZBRDfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:35:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59002
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbZBRDf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:35:29 -0500
Date: Tue, 17 Feb 2009 19:35:13 -0800 (PST)
Message-Id: <20090217.193513.253367372.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/43] drivers/net/usb: fix sparse warnings: Should it
 be static?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214738.24377.82100.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214738.24377.82100.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:47:47 +0100

> Impact: Make symbols static.
> 
> Fix this sparse warnings:
>   drivers/net/usb/hso.c:1249:6: warning: symbol 'hso_unthrottle_tasklet' was not declared. Should it be static?
>   drivers/net/usb/hso.c:1268:6: warning: symbol 'hso_unthrottle_workfunc' was not declared. Should it be static?
>   drivers/net/usb/hso.c:1466:5: warning: symbol 'tiocmget_submit_urb' was not declared. Should it be static?
>   drivers/net/usb/smsc95xx.c:62:5: warning: symbol 'turbo_mode' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
