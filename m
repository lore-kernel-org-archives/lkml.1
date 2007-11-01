Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXKAWHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXKAWHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbXKAWHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:07:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbXKAWH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:07:29 -0400
Date: Thu, 01 Nov 2007 15:07:23 -0700 (PDT)
Message-Id: <20071101.150723.30590053.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: djohnson+linux-kernel@sw.starentnetworks.com, greearb@candelatech.com,
       shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <472A4D5C.2070301@hp.com>
References: <472A49BD.6000802@hp.com>
	<20071101.145956.63020380.davem@davemloft.net>
	<472A4D5C.2070301@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Thu, 01 Nov 2007 15:04:12 -0700

> David Miller wrote:
> > From: Rick Jones <rick.jones2@hp.com>
> > Date: Thu, 01 Nov 2007 14:48:45 -0700
> > 
> > 
> >>One could I suppose try to ammend the information passed to allow
> >>tcpdump to say "oh, this was a tx packet on the same machine on
> >>which I am tracing so don't worry about checksum mismatch"
> > 
> > 
> > We do this already!
> 
> I'll try to go pester folks in tcpdump-workers then.

The thing to check is "TP_STATUS_CSUMNOTREADY".

When using mmap(), it will be provided in the descriptor.  When using
recvmsg() it will be provided via a PACKET_AUXDATA control message
when enabled via the PACKET_AUXDATA socket option.


