Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYHRLAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYHRLAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYHRK7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:59:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4637 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751642AbYHRK7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:59:49 -0400
Date: Fri, 15 Aug 2008 16:37:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080815143703.GB8860@ucw.cz>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814155028.GB8256@mit.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-08-14 11:50:28, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 09:48:33AM -0400, Eric Paris wrote:
> > 
> > There needs to be a way to say that an inode in cache needs to be
> > rescanned.  3 states this flag can be.  Clean, Dirty, Infected.  The
> > current talpa solution involves a global monotomically increasing
> > counter every time you change virus defs or make some "interesting"
> > change.  If global == inode flag we are clean.  If global == negative
> > inode flag we are infected.  if global > inode flag we are dirty and
> > need a scan.
> 
> "Infected" just means to instantly return an error when the file is
> opened or if an already opened file descriptor is read or mmap'ed,
> right?  If file is already mmaped(), what's the plan?  Send a kill -9

Me thinks about naming my machine
host-inline-real-virus-or-at-least-identifiable-part-here.cz, then
having fun with people not able to access their apache logs.

Returning an error when you think you see a virus is a great
invitation to DoS attack, really.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
