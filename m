Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYGQTRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYGQTRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbYGQTQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:16:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbYGQTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:16:56 -0400
Date: Thu, 17 Jul 2008 12:16:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807171154560.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807171212500.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org>
 <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807171402110.2965@localhost.localdomain> <alpine.LFD.1.10.0807171154560.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Linus Torvalds wrote:
> 
> No, what others do (if they know the tricks) is to say something like:
> 
> 	git rebase -i <starting-point>

Oh, and before anybody goes any further with this: it's a very convenient 
feature, but it _is_ still technically nothing but a very nice interface 
to cherry-picking and rebasing history. 

So all the caveats about _not_ doing this with public history that others 
have already seen and possibly merged are still in place. That part 
doesn't change at all.

So it's great to do with private changes to clean them up before 
publicizing them, or possibly with branches that you have explicitly told 
people are _not_ stable, but it is still very much about creating a 
totally new history.

			Linus
