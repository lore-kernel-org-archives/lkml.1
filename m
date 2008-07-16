Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYGPA1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYGPA1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbYGPAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:25:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759388AbYGPAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:25:08 -0400
Date: Tue, 15 Jul 2008 17:24:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D5729.14854.1CA5C3EB@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807151716510.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3C17.31467.1C3C0441@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org> <487D5729.14854.1CA5C3EB@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
> 
> we went through this and you yourself said that security bugs are *not*
> treated as normal bugs because you do omit relevant information from such
> commits

Actually, we disagree on one fundamental thing. We disagree on 
that single word: "relevant".

I do not think it's helpful _or_ relevant to explicitly point out how to 
tigger a bug. It's very helpful and relevant when we're trying to chase 
the bug down, but once it is fixed, it becomes irrelevant.

You think that explicitly pointing something out as a security issue is 
really important, so you think it's always "relevant". And I take mostly 
the opposite view. I think pointing it out is actually likely to be 
counter-productive.

For example, the way I prefer to work is to have people send me and the 
kernel list a patch for a fix, and then in the very next email send (in 
private) an example exploit of the problem to the security mailing list 
(and that one goes to the private security list just because we don't want 
all the people at universities rushing in to test it). THAT is how things 
should work.

Should I document the exploit in the commit message? Hell no.  It's 
private for a reason, even if it's real information. It was real 
information for the developers to explain why a patch is needed, but once 
explained, it shouldn't be spread around unnecessarily.

			Linus
