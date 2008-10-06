Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYJGNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYJGNIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYJGNG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:06:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52937 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753748AbYJGNGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:55 -0400
Date: Mon, 6 Oct 2008 17:09:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: david@lang.hm, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, peterz@infradead.org, Jonathan.Press@ca.com,
       riel@redhat.com
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
	system (intended for antivirus scanning and file indexers)
Message-ID: <20081006150858.GA1380@ucw.cz>
References: <1222463220.2872.193.camel@localhost.localdomain> <alpine.DEB.1.10.0809262259290.4229@asgard.lang.hm> <20080927122031.2d4dd1b0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927122031.2d4dd1b0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > sending a message out for every READ/WRITE seems like it will generate a 
> > LOT of messages, and very few will be ones that anyone cares about.
> 
> On read there isn't much point anyway, on write if you simply send one,
> save an event counter number and don't send another until the last one is
> cleared it all works well. When the last event is cleared if another
> event has occurred then the event counter will have changed so you know
> to send one immediately, if the app doesn't want to receive them for a
> while it can just hang onto the event for a minute or two before clearing
> it.

Actually both read and write seems useless, as both can be bypassed by
mmap...?

								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
