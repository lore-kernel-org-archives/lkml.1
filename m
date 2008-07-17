Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbYGQQDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbYGQQDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbYGQQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:02:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761085AbYGQQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:02:46 -0400
Date: Thu, 17 Jul 2008 09:02:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807170850470.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <487EEAEB.4050009@firstfloor.org> <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Linus Torvalds wrote:
> 
> But I *really* hate pulling from somebody, and seeing commit dates that 
> are from five minutes ago, and based on something that I had just pushed 
> out (which was essentially the case for this round of ACPI changes).

And Andi, before this goes any further, I'd like to say that (a) no, I 
don't hate you and (b) sorry in advance and in retrospect for my obviously 
abrasive personality and just being harsh.

In particular, this is something that I have gone through with a _lot_ of 
maintainers. So you don't need to feel bad about it. Ingo and Thomas 
obviously did the very same thing not that long ago.

And Davem had the same issue in the networking tree - most of the times 
when I pulled, I could tell that he had _just_ rebased the whole series, 
and I just knew that it had gotten effectively zero testing in that 
particular configuration.

For other trees it's still ongoing: you can generally trivially tell by 
looking at the merges and the dates of the commits relative to them and 
'base' they are done on top of. 

So you're definitely not alone. There are people who have done the same 
thing, and in many cases they did it for months. I'll happily try to help 
you with any git issues, and we can even change git itself to help with 
some things (historically we certainly have - I certainly hope that the 
need for it is going away, though). 

And I can also report that the people who then re-learnt their workflow 
and got used to maintaining several queues and not always working at the 
top of the tree and rebasing on top of whatever "random Linus kernel of 
the moment" (in order to actually work with and test what they eventually 
ask me to pull!) have so far been pretty enthusiastic about the workflow 
they learn once they pick it up.

And to give them credit for being smarter them me, others (like Jeff) 
started doing the whole "many different branches" thing long before I 
personally even realized how helpful it is.

And as mentioned, some still use the "queue on top of the most recent 
version" model, and when it's something fairly far away in the periphery 
and doesn't impact others, I don't really care. If it hadn't been for the 
PCI merge bringing up the issue, I'd have ignored the ACPI case too.

			Linus
