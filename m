Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYFQVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYFQVcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYFQVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:32:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755454AbYFQVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:32:23 -0400
Date: Tue, 17 Jun 2008 14:31:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <48582C18.4090900@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0806171429010.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <87od5zwzh2.fsf@basil.nowhere.org> <alpine.LFD.1.10.0806171412470.2907@woody.linux-foundation.org> <48582C18.4090900@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> Loads are not supposed to fault in copy_to_user(). Only stores are.

Andi, just shut up already.

It is "copy_user". Notice the lack of "from" or "to". That code handles 
*both* copy_to_user and copy_from_user.

> If your patch fixes something then the main wrong thing is the caller
> who passes a faulting source address.

Andi, SHUT THE F*CK UP. Read the code. Read the patch. Sorry for ever 
involving you. I don't want to hear your idiotic whining.

		Linus
