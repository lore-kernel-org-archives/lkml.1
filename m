Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYHASPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYHASPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYHASPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:15:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYHASPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:15:34 -0400
Date: Fri, 1 Aug 2008 11:14:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's
 subclass
In-Reply-To: <489350AE.1030609@goop.org>
Message-ID: <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org>
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins> <489350AE.1030609@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Jeremy Fitzhardinge wrote:
> 
> Hey, can I use this to suppress the spurious lockdep warnings I get when I try
> to hold more than one pte lock at once?

So how sure are you that they are spurious?

			Linus
