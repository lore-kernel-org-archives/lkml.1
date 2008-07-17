Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYGQPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYGQPDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbYGQPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:03:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755969AbYGQPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:03:41 -0400
Date: Thu, 17 Jul 2008 08:03:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <487EE940.1050007@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Andi Kleen wrote:
> 
> My plan was to keep everything in quilt and just regenerate for the pull.
> Please let me know if it's now not allowed anymore to use quilt.

End-point developers can use quilt all thei like.

But people cannot and *MUST NOT* destroy other peoples work with quilt, 
nor make it harder for people to share commits.

Len had apparently left a nice topic tree for you. You took that work, and 
then destroyed it. And yes, it is noticeable: Jesse had shared some of the 
work from Len by pulling one of the branches (the 'suspend' branch), and 
then you literally re-wrote _public_ history, so now tohose patches are 
duplicated.

Now, duplicate patches happen, and that's not a huge technical issue (most 
of the time it all merges cleanly, and it was just three patches this 
time), but if you're going to rebase stuff, you're basically making it 
impossible for people to share work with you. They can never rely on your 
git trees, because your git threes are all throw-away.

Btw, being throw-away also means that they get essentially no testing. 
They get rewritten each time, so even if you expose them to something like 
linux-next and they get testing there, when you rebase them, the end 
result is something *different*, and a lot of the test coverage goes away.

See the discussion from May about the x86 tree. I don't have it online in 
my archives any more, but google finds

	http://kerneltrap.org/Linux/Git_Management

which has at least a big part of the discussion in one readable page.

So no, there's nothing wrong with a quilt interface. But there _is_ 
something wrong with a maintainer that makes it harder for other people 
(in this case Jesse) to work with him, because he destroys history.

		Linus
