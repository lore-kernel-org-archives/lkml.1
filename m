Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYAMRTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYAMRTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYAMRT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:19:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2668 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752394AbYAMRT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:19:28 -0500
Date: Sun, 13 Jan 2008 17:19:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>,
       Valerie Henson <val.henson@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080113171916.GB4132@ucw.cz>
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112145140.GB6751@mit.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-01-12 09:51:40, Theodore Tso wrote:
> On Wed, Jan 09, 2008 at 02:52:14PM +0300, Al Boldi wrote:
> > 
> > Ok, but let's look at this a bit more opportunistic / optimistic.
> > 
> > Even after a black-out shutdown, the corruption is pretty minimal, using 
> > ext3fs at least.
> >
> 
> After a unclean shutdown, assuming you have decent hardware that
> doesn't lie about when blocks hit iron oxide, you shouldn't have any
> corruption at all.  If you have crappy hardware, then all bets are off....

What hardware is crappy here. Lets say... internal hdd in thinkpad
x60?

What are ext3 expectations of disk (is there doc somewhere)? For
example... if disk does not lie, but powerfail during write damages
the sector -- is ext3 still going to work properly?

If disk does not lie, but powerfail during write may cause random
numbers to be returned on read -- can fsck handle that?

What abou disk that kills 5 sectors around sector being written during
powerfail; can ext3 survive that?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
