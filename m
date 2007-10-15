Return-Path: <linux-kernel-owner+w=401wt.eu-S933787AbXJOUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbXJOUGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933710AbXJOUGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:06:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49044
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933688AbXJOUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:06:13 -0400
Date: Mon, 15 Oct 2007 13:06:14 -0700 (PDT)
Message-Id: <20071015.130614.129757419.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: aarapov@redhat.com, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, davem@redhat.com, jgarzik@redhat.com
Subject: Re: [PATCH] ipv4: kernel panic when only one unsecured port
 available
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015124919.30ed8f06.akpm@linux-foundation.org>
References: <m3fy0k9yod.fsf@bandura.englab.brq.redhat.com>
	<20071015124919.30ed8f06.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 12:49:19 -0700

> This code has recently been reworked, but from my reading, that
> divide-by-zero can still occur.  And given that the numbers in
> /proc/sys/net/ipv4/ip_local_port_range are inclusive, the arithmetic in
> inet_csk_get_port() seems to just be wrong?
> 
> So we have this, against David's current devel tree:

I'm pretty sure we took care of this, but maybe not :-)
