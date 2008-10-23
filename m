Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYJWVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYJWVjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJWVj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:39:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYJWVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:39:25 -0400
Date: Thu, 23 Oct 2008 14:37:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [GIT PULL/RESEND] kernel message catalog patches
In-Reply-To: <20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.2.00.0810231433380.3287@nehalem.linux-foundation.org>
References: <1224168620.9617.14.camel@localhost> <1224230354.4631.1.camel@localhost> <20081021092148.GB4980@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.00.0810230835150.3287@nehalem.linux-foundation.org>
 <20081023210446.GA12003@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Oct 2008, Heiko Carstens wrote:
> 
> The whole point of the patch set is to add documentation for kernel
> messages that are emitted via printk. The documentation is supposed to
> help a sys admin to help understand what went wrong.

I'm still not convinced.

> Please note that this was initially an s390 only patch set but we moved
> the infrastructure to generic code since it looks like others want a
> facility like this too. iirc Andrew requested the move.

I do agree that it makes no sense as a s390 feature, but quite frankly, 
I don't think it makes sense AT ALL. It introduces the notion of fixed 
messages and people now suddenly need to worry about the hashes of the 
contents etc. Exactly the kind of thing that I don't personally EVER want 
to see, and certainly not inside the kernel.

If somebody really wants this, I seriously believe it would be better done 
as a separate out-of-kernel package. Because I don't think it's worth 
maintaining those hashed translations in-kernel, and I'm nto going to ask 
people to even bother.

But if it's in-kernel, other people are then going to complain about them 
not being maintained. And quite frankly, I'm neither willing nor 
interested in hearing those complaints or making them more "valid".

So please keep the kernel message catalog external. Or try to convince me. 
But don't send me a "please pull" without any explanation or any relevant 
convincing argument.

		Linus


