Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXFKTkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXFKTkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbXFKTkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:40:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41067 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756160AbXFKTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:40:08 -0400
Date: Mon, 11 Jun 2007 12:40:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706111239230.19654@schroedinger.engr.sgi.com>
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com> 
 <Pine.LNX.4.64.0706110918340.15466@schroedinger.engr.sgi.com> 
 <1defaf580706110943q56d83939t9ab6331cc45b4810@mail.gmail.com> 
 <Pine.LNX.4.64.0706110946430.15910@schroedinger.engr.sgi.com> 
 <1defaf580706111011w641b26fbu68d6d34028f6e953@mail.gmail.com> 
 <Pine.LNX.4.64.0706111041160.17264@schroedinger.engr.sgi.com> 
 <1defaf580706111122n78ab46c3sda05cbd4ace97319@mail.gmail.com> 
 <Pine.LNX.4.64.0706111129270.18327@schroedinger.engr.sgi.com> 
 <1defaf580706111204v35b4dcc9j5dc68e722bd384b1@mail.gmail.com> 
 <Pine.LNX.4.64.0706111208580.19316@schroedinger.engr.sgi.com>
 <1defaf580706111235p7da29d25xc33d221134f3f7a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-294191516-1181590807=:19654"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-294191516-1181590807=:19654
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 Jun 2007, H=E5vard Skinnemoen wrote:

> > We should probably make the minimum slab size dependent on
> > ARCH_KMALLOC_MINALIGN. There is no point in having smaller slabs anyway=
s.
> > They will all have the same size.
>=20
> Sounds reasonable to me.

Trouble is that ARCH_KMALLOC_MINALIGN is in bytes whereas we would need a=
=20
shift value for KMALLOC_MIN_SHIFT.

Does the latest patch work?
---1700579579-294191516-1181590807=:19654--
