Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZBRBl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZBRBl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZBRBkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:40:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47218
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbZBRBkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:40:32 -0500
Date: Tue, 17 Feb 2009 17:40:16 -0800 (PST)
Message-Id: <20090217.174016.175836359.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/43] drivers/net/skfp: fix sparse warning: Should it
 be static?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214210.24377.32244.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214210.24377.32244.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:43:15 +0100

> Impact: Move function declarations to header file.
> 
> Fix this sparse warnings:
>   drivers/net/skfp/cfm.c:146:6: warning: symbol 'all_selection_criteria' was not declared. Should it be static?
>   drivers/net/skfp/drvfbi.c:186:6: warning: symbol 'mac1_irq' was not declared. Should it be static?
>   drivers/net/skfp/drvfbi.c:284:6: warning: symbol 'read_address' was not declared. Should it be static?
>   drivers/net/skfp/drvfbi.c:323:6: warning: symbol 'init_board' was not declared. Should it be static?
>   drivers/net/skfp/fplustm.c:72:24: warning: symbol 'fddi_broadcast' was not declared. Should it be static?
>   drivers/net/skfp/fplustm.c:679:6: warning: symbol 'mac2_irq' was not declared. Should it be static?
>   drivers/net/skfp/fplustm.c:805:6: warning: symbol 'mac3_irq' was not declared. Should it be static?
>   drivers/net/skfp/fplustm.c:856:5: warning: symbol 'init_fplus' was not declared. Should it be static?
>   drivers/net/skfp/pcmplc.c:404:6: warning: symbol 'init_plc' was not declared. Should it be static?
>   drivers/net/skfp/pcmplc.c:1592:5: warning: symbol 'pcm_status_twisted' was not declared. Should it be static?
>   drivers/net/skfp/smtinit.c:68:5: warning: symbol 'init_smt' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
