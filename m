Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYHLAWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYHLAWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYHLAWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:22:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36395
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYHLAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:22:24 -0400
Date: Mon, 11 Aug 2008 17:22:24 -0700 (PDT)
Message-Id: <20080811.172224.12017598.davem@davemloft.net>
To: swise@opengridcomputing.com
Cc: rdreier@cisco.com, jgarzik@pobox.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A0C927.8020501@opengridcomputing.com>
References: <adabpzzzg81.fsf@cisco.com>
	<20080811.140918.213422266.davem@davemloft.net>
	<48A0C927.8020501@opengridcomputing.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>
Date: Mon, 11 Aug 2008 18:20:07 -0500

> David Miller wrote:
> > From: Roland Dreier <rdreier@cisco.com>
> > Date: Mon, 11 Aug 2008 09:09:02 -0700
> >
> >   
> >>  > We turn it off.  If I want to shape or filter one of these iSCSI
> >>  > connections can we turn it off?
> >>
> >> That seems like a reasonable idea to me -- the standard thing to do when
> >> a NIC offload conflicts with something else is to turn off the offload
> >> and fall back to software.
> >>     
> >
> > But as Herbert says, we can make LRO such that turning it off
> > isn't necessary.
> >
> > Can we shape the iSCSI offload traffic without turning it off?
> >   
> 
> With Chelsio's product you can do this.  Maybe Divy can provide details?

When I say shape I mean apply any packet scheduler, any netfilter
module, and any other feature we support.
