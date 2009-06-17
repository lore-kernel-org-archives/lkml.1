Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZFQTPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZFQTPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZFQTP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:15:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:55454 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZFQTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:15:25 -0400
Date: Wed, 17 Jun 2009 12:14:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <20090617183036.GA7867@mit.edu>
Message-ID: <alpine.DEB.1.10.0906171213420.22898@asgard.lang.hm>
References: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com>
 <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> <28259.1245261823@redhat.com> <20090617183036.GA7867@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Theodore Tso wrote:

> There are no magic "automounts" such that OS won't know that
> user.tytso AFS Volume in the athena.mit.edu AFS cell is at
> /afs/athena.mit.edu/user/t/y/tytso, so the only "mountpoint" that
> exists as far as AFS is concerned is at /afs --- and that in the AFS
> world, it's essentially a universal convention that AFS pathnames
> begin with "/afs", and so the AFS filesystem will always be mounted in /afs.

so does this mean that there can never be more than a single AFS 
filesystem mounted?

David Lang
