Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0CHTTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:19:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0CHTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:18:56 -0500
Date: Mon, 8 Mar 2010 19:18:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308191841.GM30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <20100308184521.GK30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:59:11AM -0800, Linus Torvalds wrote:

> > I'm not fond of selinux, to put it mildly, but "pathname-based" stuff simply
> > doesn't match how the pathname resolution is defined on Unix...
> 
> Again, I'm not claiming that we should change how "open" works and has 
> always worked. I don't even understand why you have that crazy "either or" 
> mentality to begin with. Why?
> 
> It's not "either pathname or inode". I'm saying _both_ make sense. 
> 
> In some situations, the name itself really is what is fundamentally 
> special about the file.

And mapping from names to files is a function of contents of many objects.
You need to protect that contents on all objects involved *anyway*.  Which
leaves what for "protecting by pathname"?

I'm not saying that it's either or.  I am saying that it's been oversold
to hell and back, BTW, but that's a separate story.  And I'm very sceptical
about separate protection of different directory entries, which is *all*
that is left for pathname-based stuff, AFAICS.
