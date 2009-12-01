Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZLAKuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZLAKuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZLAKuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:50:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZLAKuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:50:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091201065626.GN28962@bombadil.infradead.org>
References: <20091201065626.GN28962@bombadil.infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>, Xiaotian Feng <dfeng@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, ericvh@gmail.com
Subject: Re: [PATCH] 9p: fix build breakage introduced by 201a15428bd54f83eccec8b7c64a04b8f9431204
Date: Tue, 01 Dec 2009 10:50:02 +0000
Message-ID: <6574.1259664602@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@mcmartin.ca> wrote:

> fs/9p/cache.c: In function '__v9fs_fscache_release_page':
> fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)
> fs/9p/cache.c:346: error: (Each undeclared identifier is reported only once
> fs/9p/cache.c:346: error: for each function it appears in.)

Seems I didn't turn on all the 9P options I needed :-(

David
