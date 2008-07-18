Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYGRCD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYGRCD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYGRCDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:03:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48452
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYGRCDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:03:16 -0400
Date: Thu, 17 Jul 2008 19:03:15 -0700 (PDT)
Message-Id: <20080717.190315.186892939.davem@davemloft.net>
To: vegard.nossum@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
 overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com>
References: <20080717214222.GA29449@elte.hu>
	<19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Vegard Nossum" <vegard.nossum@gmail.com>
Date: Fri, 18 Jul 2008 01:15:47 +0200

> On Thu, Jul 17, 2008 at 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > A regression to v2.6.26:
> >
> > I started getting this skb-head corruption message today, on a T60
> > laptop with e1000:
> >
> > PM: Removing info for No Bus:vcs11
> > device: 'vcs11': device_create_release
> > =============================================================================
> > BUG skbuff_head_cache: Poison overwritten
> > -----------------------------------------------------------------------------
> >
> > INFO: 0xf658ae9c-0xf658ae9c. First byte 0x6a instead of 0x6b
> 
> 1. Notice the range. It's just a single byte.
> 2. Notice the value. It's just a ++.

It's supposed to be 0x6b, this would be a "--"

Also it (more likely IMHO) could be clearing a flag with the value 0x01.

