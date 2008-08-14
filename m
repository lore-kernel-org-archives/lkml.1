Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYHNOA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYHNOA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbYHNN7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:59:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40506 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYHNN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:59:50 -0400
Date: Thu, 14 Aug 2008 14:56:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       davecb@sun.com, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080814125613.GB2262@elf.ucw.cz>
References: <20080813065401.1bbdcb07@infradead.org> <20080813141618.696833764EA@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813141618.696833764EA@pmx1.sophos.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-13 15:16:12, tvrtko.ursulin@sophos.com wrote:
> Arjan van de Ven <arjan@infradead.org> wrote on 13/08/2008 14:54:01:
> 
> > > I am not sure what you are suggesting, and I may have missed the
> > > libmalware proposal (I don't see any mention of that specific idea in
> > > any other message).  However, just to be clear...  At no point did we
> > > suggest that the kernel would do any scanning.  What we have been
> > > interested in is a mechanism that can allow a scanning application to
> > > be notified by the kernel of specific i/o events, for those events to
> > > be blocked by the kernel until a user-space scan is done, and then the
> > > user-space scan sends back allow or deny, at which point the i/o event
> > > returns to the caller -- either success or error.  This is the only
> > > way that malware can be guaranteed of being detected when it is used
> > > (for local application purposes or for transmission to another
> > > platform) or created. 
> > 
> > this is a very broad statement that ignores the LD_PRELOAD approach,
> > and thus not true.
> 
> LD_PRELOAD does not solve at least knfsd and suid binaries. But we are 
> going in circles. :)

Yes, there are about 5 suid binaries on typical linux system. Link
them to libmalware by hand.

> > > Also, a solution that requires applications to be modified will not
> > > work, because there is no way that we would be able to get ALL
> > > applications on the machines to be modified in the required ways.  If
> > > ANY applications are not so modified, then you have an unacceptable
> > 
> > you don't need to modify applications to make them use a library...
> 
> Same is true for a kernel solution. Plus, it also works for those who make 
> system calls directly, knfsd and suid binaries, and we can have cheap and 
> ultra-efficient caching. Not much kernel code, even less complex kernel 
> code and unmeasurable impact when not used and compiled in. What are the 
> big technical objections to that?

That is does not work?

(Neither does LD_PRELOAD; it still has the old mmap problem. Too bad,
but at least you get 99.9% coverage of all the apps). 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
