Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYCWKTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYCWKTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYCWKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:19:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44299
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755529AbYCWKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:19:33 -0400
Date: Sun, 23 Mar 2008 03:19:43 -0700 (PDT)
Message-Id: <20080323.031943.23771660.davem@davemloft.net>
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       jgarzik@pobox.com, netdev@vger.kernel.org
Subject: Re: [PATCH]skge napi->poll() locking bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <200803231020.10030.mitov@issp.bas.bg>
References: <200803231020.10030.mitov@issp.bas.bg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marin Mitov <mitov@issp.bas.bg>
Date: Sun, 23 Mar 2008 10:20:09 +0200

Please send networking things at least CC:'d to netdev
as many networking developers do not subscribe to
linux-kernel

> According to: Documentation/networking/netdevices.txt:
> 
> <cite>
> napi->poll:
> ..........
> 	Context: softirq
> 	         will be called with interrupts disabled by netconsole.
> </cite>
> 
> napi->poll() could be called either with interrupts enabled 
> (in softirq context) or disabled (by netconsole), so the irq flag
> should be preserved.
> 
> Inspired by Ingo's resent forcedeth patch :-)
> 
> Regards
> 
> Marin Mitov
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

Acked-by: David S. Miller <davem@davemloft.net>
