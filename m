Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbXKCRvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbXKCRvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXKCRvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:51:08 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33843 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbXKCRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:51:07 -0400
Date: Sat, 3 Nov 2007 17:50:09 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2130568928-1194112209=:10953"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2130568928-1194112209=:10953
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 3 Nov 2007, Oliv=C3=A9r Pint=C3=A9r wrote:
> Q: It's needed auch to 2.6.22-stable?

I guess so: though SLUB wasn't on by default in 2.6.22; and it being
only a slow leak rather than a corruption, I was less inclined to
agitate about it for releases further back.

But your question makes me realize I never even looked at 2.6.23 or
2.6.22 hereabouts, just assumed they were the same; let alone patch
or build or test them.  The patches reject as such because quite a
lot has changed around (there was no struct kmem_cache_cpu in either).

A hurried look suggests that the leakage problem was there in both,
but let's wait to hear Christoph's expert opinion.

Hugh
--8323584-2130568928-1194112209=:10953--
