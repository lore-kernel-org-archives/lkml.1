Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbXL1TUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbXL1TUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXL1TUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:20:20 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10206 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXL1TUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:20:19 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: James Morris <jmorris@namei.org>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Date: Fri, 28 Dec 2007 09:21:54 -0500
User-Agent: KMail/1.9.7
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov
References: <3281504256.5618888@mail.hp.com> <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712280921.54561.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 December 2007 4:52:03 pm James Morris wrote:
> On Thu, 26 Dec 2007, Paul Moore wrote:
> > As James said I'm away right now and computer access is limited.
> > However, I'm stuck in the airport right now and spent some time looking
> > at the code ... Based on what has been found so far I wonder if the
> > problem isn't a race but a problem of skb->iif never being initialized
> > correctly?  To my untrained eye it looks like __netdev_alloc_skb()
> > should be setting skb->iif (like it does for skb->dev) but it currently
> > doesn't.
>
> ->iif will be zeroed during skb allocation, then set during
> netif_receive_skb().

So it is ... I didn't look at __alloc_skb() close enough.  Thanks.

-- 
paul moore
linux security @ hp
