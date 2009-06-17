Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbZFQTau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbZFQTau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZFQTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:30:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZFQTak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:30:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0906171213420.22898@asgard.lang.hm>
References: <alpine.DEB.1.10.0906171213420.22898@asgard.lang.hm> <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> <28259.1245261823@redhat.com> <20090617183036.GA7867@mit.edu> 
To: david@lang.hm
Cc: dhowells@redhat.com, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 20:30:23 +0100
Message-ID: <29187.1245267023@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:

> so does this mean that there can never be more than a single AFS filesystem
> mounted?

Currently, in a way, yes: the existence of pathless pioctls ensures that.

kAFS does use multiple mounts, one per volume, but they're normally rooted at
/afs.

David
