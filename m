Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbYCCSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbYCCSvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYCCSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:51:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYCCSvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:51:21 -0500
Date: Mon, 03 Mar 2008 10:51:05 -0800 (PST)
Message-Id: <20080303.105105.189914871.davem@davemloft.net>
To: hannemann@nets.rwth-aachen.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removing unneeded statement from tcp_ipv4.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <47CBFBDA.7000801@nets.rwth-aachen.de>
References: <47CBFBDA.7000801@nets.rwth-aachen.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date: Mon, 03 Mar 2008 14:23:38 +0100

> -       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval) {
> +       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval)
>                 /* Some OSes (unknown ones, but I see them on web server, which
>                  * contains information interesting only for windows'
>                  * users) do not send their stamp in SYN. It is easy case.
>                  * We simply do not advertise TS support.
>                  */
>                 tmp_opt.saw_tstamp = 0;
> -               tmp_opt.tstamp_ok  = 0;
> -       }
> +

Please don't format it like this.

When there is a multi-line comment, you should still enclose
the basic block in braces.  It's unreadable otherwise.
