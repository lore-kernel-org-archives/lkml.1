Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbZLNVCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbZLNVCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZLNVCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:02:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51262
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932821AbZLNVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:02:00 -0500
Date: Mon, 14 Dec 2009 13:02:01 -0800 (PST)
Message-Id: <20091214.130201.144162604.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: RCU detected CPU 0 stall after panic on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091214202556.GC6679@linux.vnet.ibm.com>
References: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee>
	<20091212.014002.173528710.davem@davemloft.net>
	<20091214202556.GC6679@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Dec 2009 12:25:56 -0800

> Hmmm...  At first glance, it looks like RCU should put a notifier onto
> the panic_notifier_list to disable this check.  Or is there some global
> variable that I can check?

Probably the notifier works just fine.
