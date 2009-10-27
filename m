Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZJ0FYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZJ0FYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZJ0FYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:24:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58751
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbZJ0FYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:24:05 -0400
Date: Mon, 26 Oct 2009 22:24:28 -0700 (PDT)
Message-Id: <20091026.222428.80364204.davem@davemloft.net>
To: stephen.hemminger@vyatta.com
Cc: eric.dumazet@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, opurdila@ixiacom.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] dcache: better name hash function
From: David Miller <davem@davemloft.net>
In-Reply-To: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
References: <9986527.24561256620662709.JavaMail.root@tahiti.vyatta.com>
	<19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen.hemminger@vyatta.com>
Date: Mon, 26 Oct 2009 22:19:44 -0700 (PDT)

> How important is saving the one division, versus getting better
> distribution.

80 cpu cycles or more on some processors.  Cheaper to use
jenkins with a power-of-2 sized hash.
