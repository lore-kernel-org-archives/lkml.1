Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0CHSyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:54:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37068 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0CHSyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:54:03 -0500
Date: Mon, 8 Mar 2010 18:53:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308185346.GL30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <20100308184521.GK30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308184521.GK30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 06:45:21PM +0000, Al Viro wrote:
> On Mon, Mar 08, 2010 at 10:08:31AM -0800, Linus Torvalds wrote:
> 
> > In other words: it really _does_ make more sense to say "this process has 
> > rights to overwrite the path '/etc/passwd'" than it does to try to label 
> > the file. The _fundamental_ rule is about the pathname. The labeling comes 
> > about BECAUSE YOU USED A HAMMER FOR A SCREW.
> > 
> > I really don't understand why some people are unable to admit this fact. 
> 
> Because you don't have to use that pathname to modify the bits returned
> by read() after open() on that pathname?
> 
> I'm not fond of selinux, to put it mildly, but "pathname-based" stuff simply
> doesn't match how the pathname resolution is defined on Unix...

PS: at that point the *only* things I care about wrt "security" junk are
	* it shouldn't create new assertions to keep for VFS and fs code
	* it shouldn't break the normal Unix permissions for boxen that
sanely have all that crap disabled
	* it shouldn't make one vomit just from RTFS
	* it shouldn't create obvious rootholes when enabled
	* it shouldn't add overhead from hell
	* it shouldn't try to hide the violations of the conditions above

My opinion of the "security community" is worse than yours, BTW.  You have
decided that to let their stuff in; IMO it had been a mistake from the very
beginning, but that's your tree.
