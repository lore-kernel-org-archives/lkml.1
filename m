Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYGLS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYGLS3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYGLS3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:29:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYGLS3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:29:04 -0400
Date: Sat, 12 Jul 2008 11:28:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080712111501.30b91f58@infradead.org>
Message-ID: <alpine.LFD.1.10.0807121127110.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org> <4878883F.10004@gmail.com> <4878B4B5.5060007@gmail.com> <20080712075532.13483b21@infradead.org> <alpine.LFD.1.10.0807121044000.2875@woody.linux-foundation.org>
 <20080712111501.30b91f58@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Arjan van de Ven wrote:
> 
> what I'm seeing is not super new; even 2.6.25 has the behavior already
> (and with latencytop it's very visible behavior; before changing the
> tunable I see 2+ second delays in user apps, after the tunable change
> they're down significantly)

Yeah, I think people said it's more visible, and pointed back to 2.6.23 or 
something being better. So no, I don't think anybody really claimed this 
as a regression from 25.

			Linus
