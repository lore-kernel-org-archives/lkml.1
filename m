Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZJMKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZJMKWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbZJMKWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:22:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48077
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbZJMKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:22:41 -0400
Date: Tue, 13 Oct 2009 03:22:37 -0700 (PDT)
Message-Id: <20091013.032237.45775304.davem@davemloft.net>
To: ctrixk@navynet.it
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AD44435.3050703@navynet.it>
References: <r-4Wjt4coy.A.CwC.Wal0KB@chimera>
	<20091012.034224.64980795.davem@davemloft.net>
	<4AD44435.3050703@navynet.it>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Massimo Cetra <ctrixk@navynet.it>
Date: Tue, 13 Oct 2009 11:11:17 +0200

> Here, vserver is not involved, and the problem starts at drbd which
> lives in kernel space (the other oops started at ocfs2).
> 
> Both ocfs2 and drbd make heavy use of network I/O so i guess the
> problem is something in the network layer.
> 
> Anything i can do to help to debugging and solving this issue ?

Is all of your traffic going over virtio_net?
