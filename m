Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbYDYSOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbYDYSOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765060AbYDYSNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:13:30 -0400
Received: from gw.goop.org ([64.81.55.164]:41949 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762180AbYDYSN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:13:28 -0400
Message-ID: <48121F43.3060902@goop.org>
Date: Fri, 25 Apr 2008 11:13:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> With each invocation being thousands of instructions and a cross-CPU IPI 
> for the tlb flush, that kind of stuff adds up. We're likely talking real 
> fractions of a second, rather than milliseconds.

Doesn't vunmap batch the cross-CPU tlb flushes to amortize the cost?  
Hm, no, it doesn't seem to.  Oh, right, it was one of Nick's TBDs.

    J
