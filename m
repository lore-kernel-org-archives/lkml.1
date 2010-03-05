Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0CEB3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:29:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab0CEB3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:29:11 -0500
Date: Thu, 4 Mar 2010 17:28:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle McMartin <kyle@mcmartin.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: Upstream first policy
In-Reply-To: <20100305011917.GH12443@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.1003041723360.3768@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
 <20100305011917.GH12443@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Kyle McMartin wrote:
> 
> I recommend you don't look at Ubuntu, we might have a lot of extra
> crud[2] in the kernel if you do. :) (Actually, shockingly less than I
> thought, just apparmor, aufs, ndiswrapper are the obvious ones.)

Ok, so ndiswrapper falls under the "yeah, no" heading.

But apparmor was supposed to be on the "yeah, we'll merge it" path, I 
talked to somebody about it not _that_ long ago. Some of the security 
people object, but they object for all the wrong reasons and I really do 
think that since it's getting used, we really should merge it.

Although there was _some_ noise about Ubuntu trying to move away from it.. 
But that may have been more of the whole FUD thing from the people who for 
some unfathomable reason think that inodes are more important than 
pathnames.

aufs I'll leave at Al's mercy. 

			Linus
