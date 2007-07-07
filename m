Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbXGGCDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbXGGCDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXGGCDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:03:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbXGGCDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:03:35 -0400
Date: Fri, 6 Jul 2007 19:03:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1: SLUB_DEBUG=n compile error
In-Reply-To: <20070707015021.GZ3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707061902200.3257@schroedinger.engr.sgi.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070707015021.GZ3492@stusta.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1701336060-1183773814=:3257"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1701336060-1183773814=:3257
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 7 Jul 2007, Adrian Bunk wrote:

> With CONFIG_SLUB_DEBUG=3Dn:

Why switch CONFIG_SLUB_DEBUG off? This is an option for embedded systems.=
=20
Unlikely to occur on NUMA.

> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c: In function =
=FF=FFinit_kmem_cache_node=FF=FF:
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/mm/slub.c:1873: error: =
=FF=FFstruct kmem_cache_node=FF=FF has no member named =FF=FFfull=FF=FF
> ...
> make[2]: *** [mm/slub.o] Error 1

A fix for this is already in Andrew's tree.
---1700579579-1701336060-1183773814=:3257--
