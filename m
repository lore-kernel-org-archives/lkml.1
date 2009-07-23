Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZGWA71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZGWA71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZGWA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:59:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:55994 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZGWA70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:59:26 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Linux-Arch <linux-arch@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       linux-kernel@vger.kernel.org,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <74BA64FD-0DFF-45A2-868D-A001D9BA496F@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1248310415.3367.22.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Date: Wed, 22 Jul 2009 19:59:08 -0500
References: <20090715074952.A36C7DDDB2@ozlabs.org> <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop> <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain> <1248310415.3367.22.camel@pasglop>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22, 2009, at 7:53 PM, Benjamin Herrenschmidt wrote:

> On Wed, 2009-07-22 at 09:31 -0700, Linus Torvalds wrote:
>>> CC'ing Linus here. How do you want to proceed with that merge ?  
>>> (IE. so
>>> far nobody objected to the patch itself)
>>
>> Maybe you can put it as a separate branch in -next, and have it  
>> merged
>> before the stuff that depends on it, and then just sending it to me  
>> (as a
>> git branch or patch or whatever) in the first day of the merge  
>> window?
>
> Hrm... my powerpc-next branch will contain stuff that depend on it, so
> I'll probably have to pull it in though, unless I tell all my
> sub-maintainers to also pull from that other branch first :-)

Can you not cherry pick it into powerpc-next to 'pull it through'?

- k
