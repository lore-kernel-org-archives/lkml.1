Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYH0XOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYH0XOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYH0XNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:13:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYH0XNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:13:54 -0400
Date: Wed, 27 Aug 2008 16:12:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <alpine.LFD.1.10.0808271551380.3419@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808271611230.3419@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <20080827230828.4285022b@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
 <20080827232803.2ba8dd96@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271551380.3419@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Linus Torvalds wrote:
> 
> I wonder if I could essentially automate something to do the conversion..

Hmm. compat_ioctl() actually has exactly the same issue. Damn.

So you can't just add the new argument, you also have to _pass_ the 
argument in the compat_ioctl handlers to the non-compat ones.

		Linus
