Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYJKQnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYJKQnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYJKQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:43:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbYJKQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:43:41 -0400
Date: Sat, 11 Oct 2008 09:43:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking for 2.6.28
In-Reply-To: <20081010.144921.115563930.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0810110941330.3402@nehalem.linux-foundation.org>
References: <20081010.144921.115563930.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, David Miller wrote:
> 
> Here are the queued up networking changes for the 2.6.28 merge window.

This generates _tons_ of new warnings for me:

  net/netfilter/nf_conntrack_ftp.c: In function ¡update_nl_seq¢:
  net/netfilter/nf_conntrack_ftp.c:340: warning: passing argument 2 of ¡nf_conntrack_event_cache¢ from incompatible pointer type
  net/netfilter/nf_conntrack_ftp.c:344: warning: passing argument 2 of ¡nf_conntrack_event_cache¢ from incompatible pointer type

Please fix ASAP.

Pulled, but unhappy about warnings in my limited configuration.

		Linus
