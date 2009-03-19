Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZCSUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZCSUxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbZCSUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:52:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56609
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZCSUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:52:56 -0400
Date: Thu, 19 Mar 2009 13:52:43 -0700 (PDT)
Message-Id: <20090319.135243.51567158.davem@davemloft.net>
To: ghaskins@novell.com
Cc: vernux@us.ibm.com, andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C23DB9.6000905@novell.com>
References: <49C1C09E.8050405@novell.com>
	<20090318.223806.123468340.davem@davemloft.net>
	<49C23DB9.6000905@novell.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>
Date: Thu, 19 Mar 2009 08:42:33 -0400

> David Miller wrote:
> > From: Gregory Haskins <ghaskins@novell.com>
> > Date: Wed, 18 Mar 2009 23:48:46 -0400
> >
> >   
> >> To see this in action, try taking a moderately large smp system
> >> (8-way+) and scaling the number of flows.
> >>     
> >
> > I can maintain line-rate over 10GB with a 64-cpu box.
> Oh man, I am jealous of that 64-way :)
> 
> How many simultaneous flows?  What hardware?  What qdisc and other
> config do you use?  MTU?  I cannot replicate such results on 10GB even
> with much smaller cpu counts.

Sun Neptune NIU 10G with 24 TX queues.

And it's all because of the number of TX queues, nothing more.

It is essential for good performance with any level of cpu
arity.

