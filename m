Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZAKVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZAKVtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbZAKVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:49:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53637
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbZAKVtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:49:36 -0500
Date: Sun, 11 Jan 2009 13:49:37 -0800 (PST)
Message-Id: <20090111.134937.135396505.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: dwmw2@infradead.org, alessandro.suardi@gmail.com, jaswinderlinux@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <58054.1231692502@turing-police.cc.vt.edu>
References: <1231676698.25018.147.camel@macbook.infradead.org>
	<1231678799.25018.195.camel@macbook.infradead.org>
	<58054.1231692502@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Sun, 11 Jan 2009 11:48:22 -0500

> One unanswered question:  What do we expect the system to do if they have this
> patch, TIGON3=y, FIRMWARE_IN_KERNEL=n, and configure a netconsole for boot
> messages?  I'm *hoping* the answer is "the netconsole doesn't come up at boot,
> but can be re-enabled via the /sys/kernel/config/netconsole interface after
> you've done an 'ifconfig eth0 up' or similar, or do a 'modprobe netconsole'.
> 
> Those seem like reasonable semantics to me - anybody got a different opinion?

Even better, how about nfsroot?  There is no "later", either you
can mount to root filesystem or you fail.
