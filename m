Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbYB2SnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbYB2SnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbYB2Smh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:42:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933283AbYB2Smg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:42:36 -0500
Date: Fri, 29 Feb 2008 10:42:35 -0800 (PST)
Message-Id: <20080229.104235.192308716.davem@davemloft.net>
To: paulus@samba.org
Cc: mingo@elte.hu, alexey.zaytsev@gmail.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <18375.59486.392919.984544@cargo.ozlabs.ibm.com>
References: <20080228201315.GA30736@elte.hu>
	<20080228201613.GA30999@elte.hu>
	<18375.59486.392919.984544@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Fri, 29 Feb 2008 22:11:26 +1100

> On powerpc we use the timebase register, which is synchronized across
> CPUs, so if this will add unnecessary overhead, we will want to way to
> turn it off on powerpc (assuming this ends up going upstream).

Similarly on sparc64, all of our TSCs are fully synchronized so
this complexity is completely unnecessary.
