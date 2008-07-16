Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYGPBIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYGPBIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYGPBI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYGPBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:08:29 -0400
Date: Tue, 15 Jul 2008 18:08:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D6344.18581.1CD50DA5@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807151801280.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D5729.14854.1CA5C3EB@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151716510.2867@woody.linux-foundation.org> <487D6344.18581.1CD50DA5@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
> 
> > And I take mostly the opposite view. I think pointing it out is
> > actually likely to be counter-productive. 
> 
> you keep saying that, but you don't explain *why*.
> 
> > For example, the way I prefer to work is to have people send me and the 
> > kernel list a patch for a fix, and then in the very next email send (in 
> > private) an example exploit of the problem to the security mailing list 
> > (and that one goes to the private security list just because we don't want 
> > all the people at universities rushing in to test it). THAT is how things 
> > should work.
> 
> fine with me, i wasn't talking about that at all though ;).

Oh, so now you're suddenly fine with not doing "full disclosure"?

Just a few emails ago you berated me for not doing full disclosure, but 
now you're saying it is fine?

Can you now admit that it's a gray line, and that we just have very 
different opinions of where the line is drawn?

> 1. simple words/phrases that one can grep for (mentally or automated)
>    examples: 'security', 'exploitable', 'DoS', 'buffer overflow', etc

I literally draw the line at anything that is simply greppable for. If 
it's not a very public security issue already, I don't want a simple "git 
log + grep" to help find it.

That said, I don't _plan_ messages or obfuscate them, so "overflow" might 
well be part of the message just because it simply describes the fix. So 
I'm not claiming that the messages can never help somebody pinpoint 
interesting commits to look at, I'm just also not at all interested in 
doing so reliably.

> i believe 3-5 are definitely not commit message material. 1 or 2 are.
> 5 should never be published or disseminated, 3 and 4 may be distributed
> to interested parties.

And I believe you now at least understand the difference. I draw the line 
between 0 and 1, where 0 is "explain the fix" - which is something that 
any - and every - commit message should do.

			Linus
