Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYH0XBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYH0XBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYH0XBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:01:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbYH0XBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:01:17 -0400
Date: Wed, 27 Aug 2008 16:00:29 -0700 (PDT)
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
In-Reply-To: <20080827232803.2ba8dd96@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808271551380.3419@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <20080827230828.4285022b@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
 <20080827232803.2ba8dd96@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Alan Cox wrote:
> 
> I'll take a crack at it tomorrow - but if its 185 entries then it
> probably wants to go into -next instead.

Being more careful.. This:

	git grep 'unlocked_ioctl.*=' |
		sed 's/^.*=[ 	]*\([_a-zA-Z0-9]*\).*$/\1/' |
		uniq | wc

says that ther are 160 distinct cases. I'm not sure it catches everything 
exactly, but it will be reasonably close, at least.

I wonder if I could essentially automate something to do the conversion..

		Linus
