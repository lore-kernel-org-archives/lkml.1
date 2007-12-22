Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbXLVEgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbXLVEgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 23:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXLVEgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 23:36:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59535
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbXLVEgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 23:36:41 -0500
Date: Fri, 21 Dec 2007 20:36:40 -0800 (PST)
Message-Id: <20071221.203640.46152937.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mtk.manpages@googlemail.com, akpm@linux-foundation.org, lkml@davidb.org,
       paulus@samba.org, drepper@redhat.com, cfriesen@nortel.com,
       schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071222015311.GB4477@one.firstfloor.org>
References: <20071221.174124.208826257.davem@davemloft.net>
	<20071221.174547.136433173.davem@davemloft.net>
	<20071222015311.GB4477@one.firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Sat, 22 Dec 2007 02:53:11 +0100

> > And to handle potentially ambiguous cases we, for a long time, have
> > the force_successful_syscall_return() arch hook. 
> 
> Ah I see what you mean now.
> 
> Thanks for the clarification.

Thanks for continuing to insist it's "impossible" :-)
