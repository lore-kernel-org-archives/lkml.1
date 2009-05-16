Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZEPQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZEPQTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZEPQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:19:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbZEPQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:19:42 -0400
Date: Sat, 16 May 2009 09:17:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oliver Neukum <oliver@neukum.org>
cc: security@kernel.org, Linux@hera.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>, List <linux-kernel@vger.kernel.org>,
       Arjan@hera.kernel.org, stable@kernel.org, Dave Jones <davej@redhat.com>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Eric Paris <eparis@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Alan@hera.kernel.org, Jake Edge <jake@lwn.net>,
       Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Security] [patch] random: make get_random_int() more random
In-Reply-To: <alpine.LFD.2.01.0905160854570.3301@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905160911400.3301@localhost.localdomain>
References: <20090505202219.GL31071@waste.org> <20090516135828.GA25283@1wt.eu> <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain> <200905161754.03472.oliver@neukum.org> <alpine.LFD.2.01.0905160854570.3301@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Linus Torvalds wrote:
>
> So "one of X known functions" does not help

Side note - here the keyword is "X known functions". If the function 
simply isn't known at all, you've now made it harder by a _much_ higher 
factor. If the function is any good (ie doesn't leave any patterns to 
guess what function it is), you really basically have to first solve that 
independent problem.

And the space of possible functions is pretty damn large, even if you 
start with some assumption ("some combination of known good cryptographic 
hashes + some unknown seeding algorithm and data").

So practically speaking, nobody ever cracks those things without somehow 
decoding the function itself (through doing something like disassembling 
obfuscated code).

				Linus
