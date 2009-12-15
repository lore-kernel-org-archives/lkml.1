Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZLOOr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZLOOr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZLOOr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:47:57 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:38240 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZLOOr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:47:57 -0500
Date: Tue, 15 Dec 2009 08:46:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 6/8] Make slub statistics use this_cpu_inc
In-Reply-To: <4B272BAC.3080502@gmail.com>
Message-ID: <alpine.DEB.2.00.0912150836190.16754@router.home>
References: <20091214220320.665065925@quilx.com> <20091214220341.901590053@quilx.com> <4B272BAC.3080502@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1983389135-1260888397=:16754"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1983389135-1260888397=:16754
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 15 Dec 2009, Eric Dumazet wrote:

> Le 14/12/2009 23:03, Christoph Lameter a =E9crit :
> > this_cpu_inc() translates into a single instruction on x86 and does not
> > need any register. So use it in stat(). We also want to avoid the
> > calculation of the per cpu kmem_cache_cpu structure pointer. So pass
> > a kmem_cache pointer instead of a kmem_cache_cpu pointer.
> >
>
> Hmm, last time I checked, [__]this_cpu_inc were not using "inc" on x86,
> but the default [__]this_cpu_add((pcp), 1)

Well the add 1 is still a single instruction so its okay. We can easily
add support for inc on x86 if makes a difference?





---1463811839-1983389135-1260888397=:16754--
