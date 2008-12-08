Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbYLHJCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbYLHJCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYLHJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:01:51 -0500
Received: from i220-221-252-159.s30.a048.ap.plala.or.jp ([220.221.252.159]:43848
	"EHLO mail.m.clustcom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751066AbYLHJBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:01:50 -0500
X-Greylist: delayed 2949 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 04:01:50 EST
Date: Mon, 8 Dec 2008 18:01:44 +0900
From: Hitoshi Mitake <mitake@clustcom.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [RFC] New functions to manipulate registers for ethtool
Message-Id: <20081208180144.3fd4cbaa.mitake@clustcom.com>
In-Reply-To: <20081208.005431.200957157.davem@davemloft.net>
References: <20081208171230.288c5ccf.mitake@clustcom.com>
	<20081208.005431.200957157.davem@davemloft.net>
Organization: Cluster Computing, Inc
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2008 00:54:31 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Hitoshi Mitake <mitake@clustcom.com>
> Date: Mon, 8 Dec 2008 17:12:30 +0900
> 
> > I want to add two new functions to ethtool.
> > 
> > One is for setting driver's registers on MMIO area like
> > --change-eeprom option.
> 
> You can map the registers into userspace using the bus
> level mmap facilities exported to userspace.
> 
> No ethtool support is necessary for this.
> 
> > Another function is for reading driver's register on MMIO.
> 
> Also not necessary, for the same reasons described
> above.

I didn't know that, thanks!
I'll work with my problems with mmap and userspace program.
