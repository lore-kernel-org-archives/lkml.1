Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276Ab0AGREk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0AGREk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011Ab0AGREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:04:39 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:34468 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0AGREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:04:38 -0500
Date: Thu, 7 Jan 2010 11:03:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and 
 add_local_return()
In-Reply-To: <8bd0f97a1001061123w15278d0cr4e74c88f22fa6e6e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001071102230.901@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com>  <8bd0f97a1001051417w288440b4h65b6b01d4ad36a72@mail.gmail.com>  <alpine.DEB.2.00.1001051620030.9108@router.home>
 <8bd0f97a1001061123w15278d0cr4e74c88f22fa6e6e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-426588197-1262883825=:901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-426588197-1262883825=:901
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 6 Jan 2010, Mike Frysinger wrote:

> >> > +static inline unsigned long __add_return_local_generic(volatile voi=
d *ptr,
> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long val=
ue, int size)
> >>
> >> size_t for size ?
> >
> > No. It can be anything.
>
> you're passing it sizeof() which returns a size_t

Ahh  not value but the size parameter... Ok.

---1463811839-426588197-1262883825=:901--
