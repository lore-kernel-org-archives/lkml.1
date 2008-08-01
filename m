Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYHAE7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYHAE7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYHAE6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:58:54 -0400
Received: from gw.goop.org ([64.81.55.164]:47501 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYHAE6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:58:53 -0400
Message-ID: <4892980A.2010101@goop.org>
Date: Thu, 31 Jul 2008 21:58:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function	call
 IPIs
References: <488FA8A9.6000005@goop.org> <20080731220825.GD23801@elte.hu> <48923B7A.3020805@goop.org> <20080731224202.GB22426@elte.hu>
In-Reply-To: <20080731224202.GB22426@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Yes on the 64-bit side we've had NUM_INVALIDATE_TLB_VECTORS (==8) for a 
> long time, but note that 64-bit is obviously for more modern CPUs. What 
> i'm mindful about (i'm not _that_ worried) are fragile APICs and unknown 
> erratas.
>   

Well, the whole exercise is only useful if you have a relatively large 
number of CPUs, which presumably means you have relatively modern 
APICs.  If we set the number of queues to 1 for < 4 CPUs, would that 
avoid the problem APICs?

    J
