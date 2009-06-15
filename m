Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZFOMhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZFOMhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZFOMg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:36:57 -0400
Received: from tau.jukie.net ([216.239.93.128]:53158 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZFOMg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:36:57 -0400
Date: Mon, 15 Jun 2009 08:36:58 -0400
From: Bart Trojanowski <bart@jukie.net>
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [v2.6.30 nfs+fscache] kswapd1: blocked for more than 120
	seconds
Message-ID: <20090615123658.GC4721@jukie.net>
References: <20090613182721.GA24072@jukie.net> <25357.1245068384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25357.1245068384@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells <dhowells@redhat.com> [090615 08:20]:
> Bart Trojanowski <bart@jukie.net> wrote:
> 
> >   - my cachefilesd uses xfs on MD raid0 volume over two SATA disks
> 
> Is it possible for you try it with ext3 instead of XFS?  I'd be interested to
> know if this is something XFS specific.

Sure, I'll create a new lvm volume with ext3 on it and give it a try.
Can I just shutdown cachefilesd, relocate the cahce, and restart the
daemon without remounting the nfs volumes?

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
