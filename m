Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbXKCTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbXKCTks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXKCTkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:40:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35016 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXKCTkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:40:40 -0400
Date: Sat, 3 Nov 2007 19:39:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-851560062-1194118778=:15611"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-851560062-1194118778=:15611
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 3 Nov 2007, Hugh Dickins wrote:
> On Sat, 3 Nov 2007, Hugh Dickins wrote:
> > On Sat, 3 Nov 2007, Oliv=C3=A9r Pint=C3=A9r wrote:
> > > Q: It's needed auch to 2.6.22-stable?
>=20
> Okay, here's a version for 2.6.23 and 2.6.22...
> Christoph, you've now Acked the 2.6.24 one, thanks:
> do you agree this patch below should go to -stable?

Later Christoph noticed that I'm not handling the SlabDebug case right.
So stable should ignore my patch, and he will come up with another.

Hugh
--8323584-851560062-1194118778=:15611--
