Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXKLT5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXKLT5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKLT4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:56:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57977 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbXKLT4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:56:54 -0500
Date: Mon, 12 Nov 2007 11:56:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <4738AE04.1030506@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711121154270.27051@schroedinger.engr.sgi.com>
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au>
 <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com>
 <4738AE04.1030506@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-235893462-1194897413=:27051"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-235893462-1194897413=:27051
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 12 Nov 2007, Eric Dumazet wrote:

> Christoph Lameter a =E9crit :
> > On Mon, 12 Nov 2007, Herbert Xu wrote:
> >=20
> > > David Miller <davem@davemloft.net> wrote:
> > > > Each IP compression tunnel instance does an alloc_percpu().
> > > Actually all IPComp tunnels share one set of objects which are
> > > allocated per-cpu.  So only the first tunnel would do that.
> >=20
> > Ahh so the need to be able to expand per cpu memory storage on demand i=
s not
> > as critical as we thought.
> >=20
>=20
> Yes, but still desirable for future optimizations.
>=20
> For example, I do think using a per cpu memory storage on net_device refc=
nt &
> last_rx could give us some speedups.

Note that there was a new patchset posted (titled cpu alloc v1) that=20
provides on demand extension of the cpu areas.

See http://marc.info/?l=3Dlinux-kernel&m=3D119438261304093&w=3D2

---1700579579-235893462-1194897413=:27051--
