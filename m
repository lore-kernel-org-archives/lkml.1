Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZG1Lsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZG1Lsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZG1Lsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:48:40 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:44140 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZG1Lsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:48:39 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <1248466429.3567.82.camel@localhost>
References: <1248466429.3567.82.camel@localhost>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 28 Jul 2009 07:48:28 -0400
Message-Id: <1248781708.14145.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 16:13 -0400, Eric Paris wrote:

> I plan to start sending patches for fanotify in the next week or two.

Generally, I appreciate your effort (as I'm sure does everyone else).

I agree with Jamie that it's good to consider extending inotify and also
that the special socket idea probably won't work for mainline. Also:

1). Ability to watch only certain mount-points, not just directories. Or
directories and block on mount operations as Jamie suggested. Or both :)

2). Add event on mmap perhaps. Future theoretical cloud cuckoo land
ideas include forcing all mmap operations to be read-only and then
having the page fault handler fire an event for every write so that the
anti-malware thing can monitor every single touched page...joke.

3). Sounds a lot like netlink could be close enough. Kay and others have
been playing with in-kernel multiplexing and re-broadcasting of netlink
events, and I'm pretty sure most of the rest is doable.

I'm looking forward to updatedb using this. Let's try up-playing the use
cases outside malware for this stuff. I think the average person is
going to get more excited to see "Beagle done right" or "something like
Microsoft indexer service"[0] than 1970s updatedb. It's certainly a nice
and compelling reason to get this into mainline IMO.

Jon.

[0] Except anything but as crap as their version. Seriously, the last
time I used a Windows system and looked at it, the indexer was consuming
more CPU than Beagle ever did. And I liked the Beagle concept.


