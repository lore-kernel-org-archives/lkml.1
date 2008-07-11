Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYGKSSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYGKSSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYGKSR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:17:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYGKSRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:17:55 -0400
Date: Fri, 11 Jul 2008 11:17:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807111110330.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807111116460.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <20080711180757.37CC9154213@magilla.localdomain>
 <alpine.LFD.1.10.0807111110330.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Linus Torvalds wrote:
> 
> So making the callback just return an error is the right thing to do - 
> because the callers will then fix up the file offset in the last directory 
> entry and the final return value.

That said, I didn't actually _test_ my patch. That's what users are for!

		Linus
