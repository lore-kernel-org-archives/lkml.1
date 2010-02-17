Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0BQRBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:01:15 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:20772 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814Ab0BQRBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:01:14 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using fixed port numbers
Date: Wed, 17 Feb 2010 18:01:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: Cong Wang <amwang@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <4B7C159A.3060603@redhat.com> <1266424768.3075.61.camel@edumazet-laptop>
In-Reply-To: <1266424768.3075.61.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002171801.07333.opurdila@ixiacom.com>
X-OriginalArrivalTime: 17 Feb 2010 17:01:12.0049 (UTC) FILETIME=[CED4F610:01CAAFF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 February 2010 18:39:28 you wrote:
> Le jeudi 18 février 2010 à 00:13 +0800, Cong Wang a écrit :
> > I don't think so, if you want to avoid race condition, you just need to
> > write the reserved ports before any networking application starts, IOW,
> > as early as possible during boot.
> 
> Sure, but I was thinking retrieving the list of reserved port by a
> database query, using network :)
> 
> Anyway, I just feel your argument is not applicable.
> 
> Our kernel is capable of doing an intersection for us, we dont need
> to forbid user to mark a port as 'reserved' if this port is already
> blacklisted by another mechanism (for example, if this port is already
> in use)
> 

Also I believe that ip_local_port_range purpose is not to reserve *specific* 
ports. Changing this setting helps with things like increasing the port space 
for NAT or for a higher connection rate.

We add the new option for reserving *specific* ports. 

So, even from a functional perspective, it makes more sense to me to keep them 
independent, as they serve different purposes.
