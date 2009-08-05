Return-Path: <linux-kernel-owner+w=401wt.eu-S934663AbZHEQj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbZHEQj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934490AbZHEQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:39:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655AbZHEQj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:39:27 -0400
Date: Wed, 5 Aug 2009 04:05:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090805020534.GB1354@ucw.cz>
References: <1248466429.3567.82.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248466429.3567.82.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW my -@suse.cz address no longer works. pavel@ucw.cz should be ok.


> If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> must send a response before the 5 second timeout.  If no response is
> sent before the 5 second timeout the original operation is allowed.  If
> this happens too many times (10 in a row) the fanotify group is evicted
> from the kernel and will not get any new events.  Sending a response is
> done using the setsockopt() call with the socket options set to
> FANOTIFY_ACCESS_RESPONSE.  The buffer should contain a structure like:

The timeout part of interface is very ugly. Will fanotify users have
to be realtime/mlocked?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
