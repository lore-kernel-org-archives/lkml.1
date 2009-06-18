Return-Path: <linux-kernel-owner+w=401wt.eu-S1762985AbZFRMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762985AbZFRMuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762623AbZFRMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:50:05 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2647 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762972AbZFRMuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:50:02 -0400
Date: Thu, 18 Jun 2009 14:50:02 +0200
From: Olivier Galibert <galibert@pobox.com>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090618125002.GA50695@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-afs@lists.infradead.org
References: <20090617185219.GJ8633@ZenIV.linux.org.uk> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617183745.GI8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906171142580.16802@localhost.localdomain> <29139.1245266909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29139.1245266909@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 08:28:29PM +0100, David Howells wrote:
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > ... so we need a syscall that would do that "drop the caches" operation.
> > _After_ having decided that it's really needed for symlinks.
> 
> If you want to support disconnected operation, then you need a way to (a) lock
> an object in the cache, (b) unlock an object in the cache, (c) pull an object
> into the cache, (d) kick an object out of the cache, (e) ban an object from the
> cache, (f) reserve space in the cache for an object, (g) release the
> reservation on an object and (h) find out the lock/ban/reservation status of an
> object in the cache, and you'd need to support them for _all_ file types,
> including dirs, symlinks, dev files and fifos.  Probably not UNIX sockets,
> though.

If I follow correctly, what you call "object" is "anything a name can
point to in a filesystem", and you need to be able to refer to any of
them without side effects.  So, Al, whay should be used to refer to
them?

  OG.

