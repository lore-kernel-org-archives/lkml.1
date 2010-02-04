Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0BDWAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:00:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51460
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab0BDWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:00:40 -0500
Date: Thu, 04 Feb 2010 14:00:54 -0800 (PST)
Message-Id: <20100204.140054.169192674.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
       ciprian.craciun@gmail.com
Subject: Re: [PATCH] Net / pktgen: Fix freezing problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002042250.58944.rjw@sisk.pl>
References: <201002042250.58944.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 4 Feb 2010 22:50:58 +0100

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Net / pktgen: Fix freezing problem
> 
> Add missing try_to_freeze() to one of the pktgen_thread_worker() code
> paths so that it doesn't block suspend/hibernation.
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=15006
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-and-tested-by: Ciprian Dorin Craciun <ciprian.craciun@gmail.com>

Applied, thanks a lot.
