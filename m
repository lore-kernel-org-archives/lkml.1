Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbZFOOER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbZFOOER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbZFOOD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:03:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771AbZFOODz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:03:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090615123658.GC4721@jukie.net>
References: <20090615123658.GC4721@jukie.net> <20090613182721.GA24072@jukie.net> <25357.1245068384@redhat.com>
To: Bart Trojanowski <bart@jukie.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [v2.6.30 nfs+fscache] kswapd1: blocked for more than 120 seconds
Date: Mon, 15 Jun 2009 15:03:47 +0100
Message-ID: <25124.1245074627@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski <bart@jukie.net> wrote:

> Sure, I'll create a new lvm volume with ext3 on it and give it a try.
> Can I just shutdown cachefilesd, relocate the cahce, and restart the
> daemon without remounting the nfs volumes?

Yes...  But it won't begin caching any files that are already in the inode
cache in memory until they're discarded from the icache and are iget'd
again...  Which is something else I need to look at.

David
