Return-Path: <linux-kernel-owner+w=401wt.eu-S1763085AbXHaFrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763085AbXHaFrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXHaFq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:46:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43964
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXHaFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:46:58 -0400
Date: Thu, 30 Aug 2007 22:46:57 -0700 (PDT)
Message-Id: <20070830.224657.28395409.davem@davemloft.net>
To: sukadev@us.ibm.com
Cc: xemul@openvz.org, akpm@osdl.org, oleg@tv-sign.ru,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Remove write-only variable from pktgen_thread
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070829213356.GC18542@us.ibm.com>
References: <46D572FA.9090302@openvz.org>
	<20070829213356.GC18542@us.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: sukadev@us.ibm.com
Date: Wed, 29 Aug 2007 14:33:56 -0700

> Pavel Emelianov [xemul@openvz.org] wrote:
> | The pktgen_thread.pid is set to current->pid and is never used
> | after this. So remove this at all.
> | 
> | Found during isolating the explicit pid/tgid usage.
> | 
> | Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> Good observation that its not being used :-)
> 
> Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Patch applied, thanks.
