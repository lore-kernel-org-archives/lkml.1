Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYGODbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYGODbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYGODbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:31:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbYGODbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:31:22 -0400
Date: Mon, 14 Jul 2008 20:29:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487C1648.5070409@garzik.org>
Message-ID: <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Jeff Garzik wrote:
> 
> Do you really think embedded system and micro distro authors are in 100%
> agreement that /lib/firmware is best for their situation?  Really?

Umm. Why are you bringing up these total red herrings?

Those embedded systems can just build everything into one image, and are 
much better off using no modules at all.

But how about instead of complaining, help add the infrastructure then, so 
that you can insert those firmware things into modules and still use just 
one single interface? 

Move _forward_, not backwards.

			Linus
