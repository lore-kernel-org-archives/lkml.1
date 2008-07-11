Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYGKSLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYGKSLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYGKSLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:11:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbYGKSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:11:06 -0400
Date: Fri, 11 Jul 2008 11:10:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Linus Torvalds wrote:
> 
> But it would be really good to have the thing bisected regardless of what 
> it is.

Btw, did any of the impacted people test -rc9? Edwin's report is about 
-rc2 and -rc8, and one of the things we fixed since -rc8 is that incorrect 
and unintentional nr_zones zeroing that effectively disabled kswapd - and 
made everybody do synchronous memory freeing when they wanted to allocate 
more memory.. That can play havoc with any interactive stuff.

		Linus
