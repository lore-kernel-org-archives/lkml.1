Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZG2UOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZG2UOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZG2UOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:14:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39968 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZG2UOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:14:20 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, malware-list@dmesg.printk.net,
       Valdis.Kletnieks@vt.edu, greg@kroah.com, jcm@redhat.com,
       douglas.leeder@sophos.com, tytso@mit.edu, arjan@infradead.org,
       david@lang.hm, jengelh@medozas.de, aviro@redhat.com, mrkafk@gmail.com,
       alexl@redhat.com, jack@suse.cz, tvrtko.ursulin@sophos.com,
       a.p.zijlstra@chello.nl, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <20090727183354.GM4231@webber.adilger.int>
References: <1248466429.3567.82.camel@localhost>
	 <20090724224813.GK27755@shareable.org>
	 <1248479367.3567.133.camel@localhost>
	 <20090725002916.GB13556@shareable.org>
	 <20090727183354.GM4231@webber.adilger.int>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:12:09 -0400
Message-Id: <1248898329.2597.57.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 12:33 -0600, Andreas Dilger wrote:
> On Jul 25, 2009  01:29 +0100, Jamie Lokier wrote:

> It might also make sense to verify that the process doing the open has
> at least permission to open the file in question (i.e. root) so that
> some unauthorized process cannot just get file handles to arbitrary files.

All current permissions between the listener process and the object are
done.  It's quite possible to get fanotify events where the fd = -EPERM.

-Eric

