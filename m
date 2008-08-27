Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYH0TvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYH0TvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYH0Tuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:50:52 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:65460 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYH0Tuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:50:52 -0400
Date: Wed, 27 Aug 2008 12:44:35 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Artem Bityutskiy <dedekind@infradead.org>
cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'Bruce Leonard'" <brucle@earthlink.net>, Bruce_Leonard@selinc.com,
       linux-kernel@vger.kernel.org, Tim Anderson <tanderson@mvista.com>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
In-Reply-To: <1219848463.18027.166.camel@sauron>
Message-ID: <Pine.LNX.4.64.0808271243200.3610@t2.domain.actdsltmp>
References: <1219817017.18027.149.camel@sauron> <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
 <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk> <1219827692.7107.170.camel@pmac.infradead.org>
 <20080827143416.GA1371@logfs.org> <1219848463.18027.166.camel@sauron>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811584-1580885661-1219866275=:3610"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811584-1580885661-1219866275=:3610
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 27 Aug 2008, Artem Bityutskiy wrote:
> > On Wed, 2008-08-27 at 16:34 +0200, J=C3=B6rn Engel wrote:
> > They certainly can, but should they?  There may be some reason to prefe=
r
> > sysfs that should be self-evident - except that I'm a bit thick and see=
m
> > to need it spelled out.  Or maybe I've just become disillusioned with
> > the practice of replacing crappy interfaces (ioctl here) with other
> > crappy interfaces (sysfs here) and having to support both for all
> > eternity.  sysctl, ioctl, proc, sysfs, debugfs, netlink, ... -
> > individually they all suck in their own peculiar way.  But together the=
y
> > create a mess I no longer dare to name.
>=20
> The plus of sysfs I see is that I can add more files to expose more
> information in sysfs, while I can not change MEMGETINFO ioctl. E.g., I
> need to expose sub-page size to user-space, and I cannot do this with
> MEMGETINFO.

You can do this with ioctls, if you designed them with extra space and
versioning from the beginning.
---1463811584-1580885661-1219866275=:3610--
