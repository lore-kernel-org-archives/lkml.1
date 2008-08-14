Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbYHNBiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbYHNBiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYHNBhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:37:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49794
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbYHNBhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:37:54 -0400
Date: Wed, 13 Aug 2008 18:37:55 -0700 (PDT)
Message-Id: <20080813.183755.72334968.davem@davemloft.net>
To: tom@opengridcomputing.com
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       swise@opengridcomputing.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A389DB.9050002@opengridcomputing.com>
References: <adatzdoiklo.fsf@cisco.com>
	<20080813.161237.10205799.davem@davemloft.net>
	<48A389DB.9050002@opengridcomputing.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Tucker <tom@opengridcomputing.com>
Date: Wed, 13 Aug 2008 20:26:51 -0500

> Can you explain how this "information" somehow doesn't qualify as 
> "state". Doesn't the next expected sequence number at the very least 
> need to be updated? una? etc...?
> 
> Could you also include the "non-state-full" information necessary to do 
> iSCSI header digest validation, data placement, and marker removal? 

It's stateless because the full packet traverses the real networking
stack and thus can be treated like any other packet.

The data placement is a side effect that the networking stack can
completely ignore if it chooses to.
