Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbYJKR6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbYJKR6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932559AbYJKR5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:57:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932552AbYJKR5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:57:32 -0400
Date: Sat, 11 Oct 2008 10:57:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking for 2.6.28
In-Reply-To: <alpine.LFD.2.00.0810110941330.3402@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810111057020.3402@nehalem.linux-foundation.org>
References: <20081010.144921.115563930.davem@davemloft.net> <alpine.LFD.2.00.0810110941330.3402@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Oct 2008, Linus Torvalds wrote:
> 
> On Fri, 10 Oct 2008, David Miller wrote:
> > 
> > Here are the queued up networking changes for the 2.6.28 merge window.
> 
> This generates _tons_ of new warnings for me:

And apparently errors for others:

 net/netfilter/ipvs/ip_vs_xmit.c: In function 'ip_vs_tunnel_xmit':
 net/netfilter/ipvs/ip_vs_xmit.c:616: error: implicit declaration of function 'ip_select_ident'

some other config-dependent breakage.

			Linus
