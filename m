Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbYEORii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbYEORii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYEORia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:38:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51675 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbYEORi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:38:29 -0400
Date: Thu, 15 May 2008 10:38:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?ISO-8859-1?Q?St=E9phane_ANCELOT?= <sancelot@free.fr>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
In-Reply-To: <4829566B.7090804@free.fr>
Message-ID: <Pine.LNX.4.64.0805151036030.18708@schroedinger.engr.sgi.com>
References: <1209462094.4816ed4e93977@imp.free.fr>
 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
 <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>
 <4821C526.8030901@free.fr> <Pine.LNX.4.64.0805071020210.3173@schroedinger.engr.sgi.com>
 <4829566B.7090804@free.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1226595496-1210873060=:18708"
Content-ID: <Pine.LNX.4.64.0805151037450.18708@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1226595496-1210873060=:18708
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0805151037451.18708@schroedinger.engr.sgi.com>

On Tue, 13 May 2008, St=E9phane ANCELOT wrote:

> I kept my kernel running with few applications for 5 days , doing
> nothing more than backing up few kb of data on disk and refresh few X app=
s.
>=20
> Ater five days the global memory available go down from 24Mb to 8Mb ...

That is normal. Linux tries to put all memory to use and will free on=20
demand.

> The are some signifiant changes in slabinfo but now, I do not know where
> to search ?

Compile the slabinfo tool.

gcc -o slabinfo linux/Documentation/vm/slabinfo.c

Then you can do

slabinfo -T

to get an overview of how much is used by slabs. But I do not see that=20
slabs are using an excessive amount. So toying around with slabinfo is=20
not going to get you anywhere.


---1700579579-1226595496-1210873060=:18708--
