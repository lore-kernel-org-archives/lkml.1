Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbYBNWsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbYBNWsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbYBNWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:48:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756823AbYBNWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:48:37 -0500
Date: Thu, 14 Feb 2008 14:49:08 -0800 (PST)
Message-Id: <20080214.144908.60077685.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: lethal@linux-sh.org
Subject: Re: + net-xfrm-statistics-depend-on-inet.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802142102.m1EL2eFg002627@imap1.linux-foundation.org>
References: <200802142102.m1EL2eFg002627@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Thu, 14 Feb 2008 13:02:40 -0800

> Subject: net: xfrm statistics depend on INET
> From: Paul Mundt <lethal@linux-sh.org>
> 
> net/built-in.o: In function `xfrm_policy_init':
> /home/pmundt/devel/git/sh-2.6.25/net/xfrm/xfrm_policy.c:2338: undefined reference to `snmp_mib_init'
> 
> snmp_mib_init() is only built in if CONFIG_INET is set.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I've applied this, thanks.
