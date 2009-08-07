Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZHGI70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZHGI70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZHGI7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:59:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36667 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbZHGI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:59:24 -0400
Date: Fri, 7 Aug 2009 09:59:02 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Douglas Leeder <douglas.leeder@sophos.com>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090807085902.GB24689@shareable.org>
References: <1248466429.3567.82.camel@localhost> <20090805020534.GB1354@ucw.cz> <200908051746.17903.tvrtko.ursulin@sophos.com> <20090806101059.GD31370@elf.ucw.cz> <4A7AAE89.20205@sophos.com> <20090806102252.GG31370@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806102252.GG31370@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2009-08-06 11:20:57, Douglas Leeder wrote:
> > You mean that in 5 seconds, you won't have any point when you can tell
> > the kernel, "I'm still working"?
> 
> Yes. Try make -j on your machine one day.

Ironically, some users report that Tracker (which uses inotify, hence
the irony) can make their system unresponsive for more than 5 seconds. :-)

-- Jamie
