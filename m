Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZDOKQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZDOKQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbZDOKPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:15:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45300
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759588AbZDOKPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:15:19 -0400
Date: Wed, 15 Apr 2009 03:15:10 -0700 (PDT)
Message-Id: <20090415.031510.162624644.davem@davemloft.net>
To: kaber@trash.net
Cc: dada1@cosmosbay.com, jpirko@redhat.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       mschmidt@redhat.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
 dev_addr_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <49E5B365.2010008@trash.net>
References: <49E5A896.90408@cosmosbay.com>
	<20090415.023104.82135803.davem@davemloft.net>
	<49E5B365.2010008@trash.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 15 Apr 2009 12:13:57 +0200

> David Miller wrote:
>> From: Eric Dumazet <dada1@cosmosbay.com>
>> Date: Wed, 15 Apr 2009 11:27:50 +0200
>> 
>>> Since you obviously need a write lock here to be sure following
>>> can be done by one cpu only.
>>>
>>> You have same problem all over this patch.
>> RTNL semaphore is held across all modification operations.
> 
> If this will also be used for multicast lists, changes can happen
> (IPv6) without the RTNL.

Indeed, that is true :-/
