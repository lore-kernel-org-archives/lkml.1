Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYHRLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYHRLAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYHRK75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:59:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4647 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753869AbYHRK74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:59:56 -0400
Date: Fri, 15 Aug 2008 16:31:06 +0200
From: Pavel Machek <pavel@suse.cz>
To: tvrtko.ursulin@sophos.com
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-kernel-owner@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       Theodore Tso <tytso@mit.edu>, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815143106.GA8860@ucw.cz>
References: <2629CC4E1D22A64593B02C43E855530304AE4BCB@USILMS12.ca.com> <20080814122800.45BA42FE810@pmx1.sophos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814122800.45BA42FE810@pmx1.sophos.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > a model other than restrictive can make sense with content security
> > > scanning.
> > 
> > I'm not sure I understand why "interest in content" means not blocking,
> > and vice versa.  However, I think this is a good idea if made more
> > explicit, i.e.:
> 
> Small misunderstanding because both would block. If you go back to Ted's 
> original post I was replying to, he was worried about how would 
> anti-malware scanning interact with HSM since both may end up using the 
> same interface. HSM, as far as I understand it, needs to block on open and 
> "plant" the right file in place, while anti-malware also needs to block 
> and examine the right content. That is why ordering matters, anti-malware 
> needs to run after the content is put in place. And that is what my idea 
> solves (slight overstatement since I spent only seconds on it) by 
> separating them in two groups of clients. First which has no interest in 
> content and second which does.

I don't see why HSMs are mixed into this discussion -- they appear
very different. For one, you probably have just one filesystem with
tape storage, so it makes sense to implement HSM at filesystem level;
probably with something like FUSE+unionfs.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
