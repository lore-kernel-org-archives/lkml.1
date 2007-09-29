Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbXI2JfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbXI2JfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXI2JfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:35:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50285
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbXI2JfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:35:10 -0400
Date: Sat, 29 Sep 2007 02:35:10 -0700 (PDT)
Message-Id: <20070929.023510.112596666.davem@davemloft.net>
To: laurent.riffard@free.fr
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc[68]-mm: network hangs
From: David Miller <davem@davemloft.net>
In-Reply-To: <46FE193E.60200@free.fr>
References: <46FD5A82.9070505@free.fr>
	<20070929013106.4f84320d.akpm@linux-foundation.org>
	<46FE193E.60200@free.fr>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Riffard <laurent.riffard@free.fr>
Date: Sat, 29 Sep 2007 11:22:06 +0200

> Could a router problem prevent "ping 127.0.0.1" from working ?

Two things that are new and could cause these problems:

1) We dynamically allocate the loopback device now.

2) We have the network namespace stuff.

Another change in this area is that we do routing cache
garbage collection from a workqueue instead of a timer
but that was a pretty straightforward transformation so
it is not high on my list of "suspects".
