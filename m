Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbYGOCev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbYGOCev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbYGOCeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:34:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbYGOCd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:33:58 -0400
Date: Mon, 14 Jul 2008 19:33:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <487C09EB.1050903@garzik.org>
Message-ID: <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <487C09EB.1050903@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Jeff Garzik wrote:
> 
> My complaints are about --not breaking stuff--, not request_firmware().

Guys, request_firmware() has been around for about five years now.

If this discussion had happened in 2003, I'd agree.

As it is, I think it's time to just face it - many people do want to have 
a unified interface (and yes, I obviously count myself in that group), and 
you can't just continue do nothing and ignore that.

Your argument seems to be that you don't want to break anything, but 
you've also clearly not wanted to _fix_ anything for the last five years. 

At some point, somebody has to just do it. And five years is _way_ long 
enough.

			Linus
