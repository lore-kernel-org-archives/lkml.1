Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbYEASxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbYEASxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYEASxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:53:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbYEASxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:53:22 -0400
Date: Thu, 1 May 2008 11:52:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Luca Tettamanti <kronos.it@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix SMP alternatives : use mutex instead of spinlock,
 text_poke is sleepable
In-Reply-To: <20080501184627.GA8853@Krystal>
Message-ID: <alpine.LFD.1.10.0805011151521.5994@woody.linux-foundation.org>
References: <20080430195110.GA28743@dreamland.darkstar.lan> <20080501130453.GA28965@Krystal> <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com> <68676e00805010944y59fbbbdcyfd6524836997d3a1@mail.gmail.com> <20080501184627.GA8853@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Mathieu Desnoyers wrote:
> 
> Yep. I think using a mutex should fix it. There is no reason to use a
> spinlock rather than a mutex here.

Is there any reason to do any locking what-so-ever?

If this code could possibly race with something else, that sounds like a 
bug in itself, no?

		Linus
