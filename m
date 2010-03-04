Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0CDUID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:08:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab0CDUIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:08:00 -0500
Date: Thu, 4 Mar 2010 12:07:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304195302.GA24856@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
 <20100304190450.GA23807@srcf.ucam.org> <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain> <20100304192524.GA24253@srcf.ucam.org> <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain> <20100304195302.GA24856@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Matthew Garrett wrote:
> 
> > IOW, we have a real technical problem here. Are you just going to continue 
> > to make excuses about it?
> 
> I'm not questioning the fact that it would be preferable to provide 
> compatibility. But that compatibility doesn't come for free - someone 
> has to implement it, and when your developer base is almost entirely 
> made up of people who are doing this because they find it fun and 
> interesting rather than because they're paid to, who's going to do it 
> and what functionality is going to be delayed as a result?

The thing is, I violently disagree with your basic premise.

The way things are done now, that developer base actually just makes 
things _harder_ for themselves. They may not be aware that they do so, and 
they may _think_ that it's easier to just ignore versioning, but they are 
wrong.

And I say that from personal experience. Doing incompatible changes in any 
code base makes everything harder. It results in users staying on old 
versions that you _know_ you don't want to support, but because of the 
incompatible change, they can't sanely upgrade. 

Seriously. 

So I bet we could do that "wrapper nouveau.so" that literally just does 
the "get version, and dlopen the _real_ nouveau-<version>.so".

Quite frankly, I don't know the XAA interfaces (or whatever they are in X 
these days), but somebody who does know them should be able to cook up 
such a wrapper in five minutes (and then spend a day testing it because of 
some silly bug, but whatever..)

Do you seriously think that that wouldn't make life easier EVEN FOR THOSE 
DEVELOPERS that you claim to speak up for?

			Linus
