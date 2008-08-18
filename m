Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYHRWj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYHRWj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYHRWjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:39:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45705 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYHRWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:39:44 -0400
Date: Tue, 19 Aug 2008 00:40:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: tvrtko.ursulin@sophos.com
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to
	a linux interface for on access scanning
Message-ID: <20080818224058.GA2311@elf.ucw.cz>
References: <20080818142511.GC8184@mit.edu> <20080818153212.6A6FD33687F@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818153212.6A6FD33687F@pmx1.sophos.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com 
> wrote:
> > > Then there is still a question of who allows some binary to declare 
> itself 
> > > exempt. If that decision was a mistake, or it gets compromised 
> security 
> > > will be off. A very powerful mechanism which must not be easily 
> > > accessible.  With a good cache your worries go away even without a 
> scheme 
> > > like this.
> > 
> > I have one word for you --- bittorrent.  If you are downloading a very
> > large torrent (say approximately a gigabyte), and it contains many
> > pdf's that are say a few megabytes a piece, and things are coming in
> > tribbles, having either a indexing scanner or an AV scanner wake up
> > and rescan the file from scratch each time a tiny piece of the pdf
> > comes in is going to eat your machine alive....
> 
> Huh? I was never advocating re-scan after each modification and I even 
> explicitly said it does not make sense for AV not only for performance but 
> because it will be useless most of the time. I thought sending out 
> modified notification on close makes sense because it is a natural point, 
> unless someone is trying to subvert which is out of scope. Other
> have 

Why do you think non-malicious applications won't write after close /
keep file open forever?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
