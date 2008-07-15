Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYGOQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYGOQmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYGOQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:42:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbYGOQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:42:31 -0400
Date: Tue, 15 Jul 2008 09:41:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807150931290.16109@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807150936070.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
 <200807151757.10626.elendil@planet.nl> <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org> <alpine.DEB.1.10.0807150931290.16109@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, david@lang.hm wrote:
>
> David W has made it very clear that the eventual intent of this patch series
> is to remove all firmware from the kernel tree and have it shipped as a
> seperate package.

I don't think that kind of black-and-white model is necessarily 
attainable. Nor do I think it's even _good_.

It's probably the right thign for _some_ firmware, assuming we have models 
that just make it easy enough - for drivers where it's generally better 
for distros to get the firmware from vendors rather than the kernel.

But there is certainly nothing inherently good in forcing a split.

I think both sides here need to calm down and stop being so extreme.

I do want request_firmware() to be the way to load firmware (and possibly 
other configuration data too, for that matter - I don't think it's 
necessarily wrong for people to "misuse" it for other long-term data 
despite the name), and I do want people to be able to update firmware 
easily without having to force a kernel bump, but I also don't think it 
means that firmware has to go away from the kernel sources.

So I think the _infrastructure_ is important. But the extreme "you have to 
split it off entirely" mindset is equally as stupid as the "you must 
compile it into the module" mindset.

			Linus
