Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752773AbYLRRsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYLRRsU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLRRsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:48:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbYLRRsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:48:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081218092557.b274e9dd.randy.dunlap@oracle.com>
References: <20081218092557.b274e9dd.randy.dunlap@oracle.com> <20081218230637.c879a046.sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 18 (fscache)
Date: Thu, 18 Dec 2008 17:47:56 +0000
Message-ID: <6448.1229622476@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Should include/linux/buffer_head.h have an empty stub for fsync_super()
> or does fscache even make sense when CONFIG_BLOCK=n?

FS-Cache might.  CacheFiles probably doesn't.

There've been discussions about a separate caching backend to deal with
non-rotating media such as large chunks of battery-backed RAM or flash.
FS-Cache might make sense in such a situation as these could be accessed in
other ways (such as through MTD or even directly).

I'll make CONFIG_CACHEFILES dependent on CONFIG_BLOCK.

David
