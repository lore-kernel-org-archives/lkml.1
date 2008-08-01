Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYHASGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYHASGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHASGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:06:44 -0400
Received: from gw.goop.org ([64.81.55.164]:46655 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYHASGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:06:44 -0400
Message-ID: <489350AE.1030609@goop.org>
Date: Fri, 01 Aug 2008 11:06:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
References: <20080731.155504.167792984.davem@davemloft.net>	 <20080801.011122.32782916.davem@davemloft.net>	 <20080801090100.GA25142@elte.hu>	 <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins>
In-Reply-To: <1217588920.9686.6.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Subject: lockdep: lock_set_subclass - reset a held lock's subclass
>
> this can be used to reset a held lock's subclass, for arbitrary-depth
> iterated data structures such as trees or lists which have per-node
> locks.
>   

Hey, can I use this to suppress the spurious lockdep warnings I get when 
I try to hold more than one pte lock at once?

    J
