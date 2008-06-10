Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYFJWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYFJWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbYFJWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:22:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058AbYFJWWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:22:12 -0400
Message-ID: <484EFE92.4000800@pobox.com>
Date: Tue, 10 Jun 2008 18:22:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] add missing lance_* exports
References: <20080609222216.GD1987@cs181133002.pp.htv.fi>
In-Reply-To: <20080609222216.GD1987@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   Building modules, stage 2.
>   MODPOST 1203 modules
> ERROR: "lance_open" [drivers/net/mvme147.ko] undefined!
> ERROR: "lance_close" [drivers/net/mvme147.ko] undefined!
> ERROR: "lance_tx_timeout" [drivers/net/mvme147.ko] undefined!
> ERROR: "lance_set_multicast" [drivers/net/mvme147.ko] undefined!
> ERROR: "lance_start_xmit" [drivers/net/mvme147.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied


