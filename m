Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYHNCFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYHNCFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYHNCFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:05:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYHNCFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:05:19 -0400
Date: Wed, 13 Aug 2008 19:05:21 -0700 (PDT)
Message-Id: <20080813.190521.224523380.davem@davemloft.net>
To: swise@opengridcomputing.com
Cc: tom@opengridcomputing.com, rdreier@cisco.com, rick.jones2@hp.com,
       jgarzik@pobox.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A38FEF.6090500@opengridcomputing.com>
References: <48A389DB.9050002@opengridcomputing.com>
	<20080813.183755.72334968.davem@davemloft.net>
	<48A38FEF.6090500@opengridcomputing.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>
Date: Wed, 13 Aug 2008 20:52:47 -0500

> How do you envision programming such a device?

There should be no special programming.

> It will need TCP and iSCSI state to have any chance of doing useful
> and productive placement of data.

The card can see the entire TCP stream, it doesn't need anything
more than that.  It can parse every packet header, see what kind
of data transfer is being requested or responded to, etc.

Look, I'm not going to design this whole friggin' thing for you guys.

I've stated clearly what the base requirement is, which is that the
packet is fully processed by the networking stack and that the card
merely does data placement optimizations that the stack can completely
ignore if it wants to.

You have an entire engine in there that can interpret an iSCSI
transport stream, you have the logic to do these kinds of things,
and it can be done without managing the connection on the card.
