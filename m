Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbXEROs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbXEROs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXEROsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:48:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756890AbXEROsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:48:12 -0400
Date: Fri, 18 May 2007 07:45:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] timerfd/eventfd context lock doesn't protect against
 poll_wait
In-Reply-To: <Pine.LNX.4.64.0705172258400.5705@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0705180744040.3890@woody.linux-foundation.org>
References: <464D2142.3070705@haxent.com.br>
 <Pine.LNX.4.64.0705172258400.5705@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 May 2007, Davide Libenzi wrote:
> 
> Thx Davi, patch is correct. Nice catch. But at this point instead of 
> ending up getting two locks, we may look into using Andrew suggestion of 
> reusing the waitqueue lock. Is it universally considered a "legal" 
> operation?

Yes. Perhaps not for drivers etc, but stuff that is deeply involved in 
waitqueue handling anyway, sure.

		Linus
