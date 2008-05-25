Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbYEYMKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbYEYMKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYEYMKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:10:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50860
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbYEYMKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:10:37 -0400
Date: Sun, 25 May 2008 05:10:32 -0700 (PDT)
Message-Id: <20080525.051032.186144643.davem@davemloft.net>
To: komurojun-mbn@nifty.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PLEASE REVERT] "Add a WARN_ON_ONCE" at
 net/sched/sch_generic.c:
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Komuro <komurojun-mbn@nifty.com>
Date: Sun, 25 May 2008 11:23:08 +0900

> Please revert the patch "Add a WARN_ON_ONCE() to
>  the transmit timeout function".
> 
> The transmit timeout sometimes happens on normal operation.
> This message annoys me.

Sometimes, but not often.

Most of the time it does indicate a bug and we absolutely cannot
diagnose it without the backtrace.
