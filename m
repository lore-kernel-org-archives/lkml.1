Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbXLZVwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbXLZVwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 16:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXLZVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 16:52:41 -0500
Received: from namei.org ([69.55.235.186]:52702 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514AbXLZVwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 16:52:41 -0500
Date: Thu, 27 Dec 2007 08:52:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Paul Moore <paul.moore@hp.com>
cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: <3281504256.5618888@mail.hp.com>
Message-ID: <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au>
References: <3281504256.5618888@mail.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2007, Paul Moore wrote:

> As James said I'm away right now and computer access is limited.  
> However, I'm stuck in the airport right now and spent some time looking 
> at the code ... Based on what has been found so far I wonder if the 
> problem isn't a race but a problem of skb->iif never being initialized 
> correctly?  To my untrained eye it looks like __netdev_alloc_skb() 
> should be setting skb->iif (like it does for skb->dev) but it currently 
> doesn't.

->iif will be zeroed during skb allocation, then set during 
netif_receive_skb().


- James
-- 
James Morris
<jmorris@namei.org>
