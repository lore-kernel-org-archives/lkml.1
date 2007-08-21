Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbXHUHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbXHUHLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHUHLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:11:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52027
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbXHUHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:11:35 -0400
Date: Tue, 21 Aug 2007 00:11:34 -0700 (PDT)
Message-Id: <20070821.001134.58787844.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: samuel@sortiz.org, linux-kernel@vger.kernel.org, dagb@cs.uit.no,
       jt@hpl.hp.com
Subject: Re: [PATCH] IRDA: Avoid a label defined but not used warning in
 irda_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708172322.34105.jesper.juhl@gmail.com>
References: <200708172322.34105.jesper.juhl@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 17 Aug 2007 23:22:33 +0200

> Hi,
> 
> Easily avoidable compiler warnings bug me.
> 
> 
> Building irmod without CONFIG_SYSCTL currently results in : 
>  net/irda/irmod.c:132: warning: label 'out_err_2' defined but not used
> 
> But that can easily be avoided by simply moving the label inside 
> the existing "#ifdef CONFIG_SYSCTL" one line above it.
> 
> This patch moves the label and buys us one less warning with no 
> ill effects.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Applied, thanks Jesper.
