Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbXKUSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbXKUSfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXKUSfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:35:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbXKUSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:35:32 -0500
Date: Wed, 21 Nov 2007 10:35:31 -0800 (PST)
Message-Id: <20071121.103531.267691506.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071121124532.GA17263@havoc.gtf.org>
References: <20071121124532.GA17263@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 21 Nov 2007 07:45:32 -0500

> 
> SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
> based on a reading of net/ipv4/udp.c.
> 
> I wonder if IPv4's CHECKSUM_PARTIAL check from udp_push_pending_frames()
> also needs to be copied to IPv6?
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

IPV6 specifies that, unlike ipv4, this no-checksum behavior
is not allowed.
