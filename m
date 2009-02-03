Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZBCHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZBCHUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 02:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZBCHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 02:20:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37116
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbZBCHUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 02:20:02 -0500
Date: Mon, 02 Feb 2009 23:19:59 -0800 (PST)
Message-Id: <20090202.231959.127283027.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sungem: limit reaches -1, but 0 tested
From: David Miller <davem@davemloft.net>
In-Reply-To: <4985D8AF.1040009@gmail.com>
References: <4984473C.1040508@gmail.com>
	<20090201.015931.127677783.davem@davemloft.net>
	<4985D8AF.1040009@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 01 Feb 2009 18:15:27 +0100

> while (limit--)
> 	if (test())
> 		break;
> 
> if (limit <= 0)
> 	goto test_failed;
> 
> In the last iteration, limit is decremented after the test to 0.
> If just thereafter test() succeeds and a break occurs, the goto
> still occurs because limit is 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Also applied, thanks.
