Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYLFHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYLFHDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYLFHDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:03:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50093
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbYLFHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:03:07 -0500
Date: Fri, 05 Dec 2008 23:03:08 -0800 (PST)
Message-Id: <20081205.230308.72594177.davem@davemloft.net>
To: nick@nick-andrew.net
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] Sample refactor of socket.c to use
 recursive printk
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081206070023.29149.92171.stgit@marcab.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
	<20081206070023.29149.92171.stgit@marcab.local.tull.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Andrew <nick@nick-andrew.net>
Date: Sat, 06 Dec 2008 18:00:23 +1100

> Sample refactor of socket.c to use recursive printk
> 
> Add a new function net_printk which takes a level argument
> (kernel message level), format string and varargs and
> calls printk with this format string and arguments:
> 
>     printk("%sNET: %v\n", level, fmt, args);
> 
> This is a proof of concept to show that recursive printk
> works and is useful.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Looks not that useful to me, to be honest.

