Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYB0T3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYB0T3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYB0T3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:29:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51329 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbYB0T3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:29:12 -0500
Date: Wed, 27 Feb 2008 21:29:08 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Guillaume Chazarain <guichaz@gmail.com>
cc: Giangiacomo Mariotti <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
In-Reply-To: <3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi>
References: <858077.97160.qm@web39709.mail.mud.yahoo.com> 
 <20080223000310.4630daa8.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi>
 <3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; boundary="=_courier-8386-1204138613-0001-2"
Content-ID: <Pine.LNX.4.64.0802272120431.1741@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--=_courier-8386-1204138613-0001-2
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0802272120432.1741@kivilampi-30.cs.helsinki.fi>
Content-Disposition: inline

On Wed, 27 Feb 2008, Guillaume Chazarain wrote:

> On Wed, Feb 27, 2008 at 10:29 AM, Ilpo Järvinen 
> <ilpo.jarvinen@helsinki.fi> wrote:
> > I did in the past a debug patch
> >  that verifies TCP's write queue state by the hard way, ie., by 
> >  bruteforce
> >  walking often enough to catch inconsistencies early enough to find 
> >  out
> >  the root cause.
> 
> Are you talking about this one:
> http://marc.info/?l=linux-netdev&m=119482084511178 ?
> I attached a forward port to current git.

No, I'd much more complete set of tests than in that one.

> I am using this patch, and caught this maybe related error while 
> Bittorrenting:
>
> KERNEL: assertion (packets <= tp->packets_out) failed at
> /home/g/linux-2.6/net/ipv4/tcp_input.c (2145)
> KERNEL: assertion (packets <= tp->packets_out) failed at
> /home/g/linux-2.6/net/ipv4/tcp_input.c (2145)
> ------------[ cut here ]------------
> WARNING: at /home/g/linux-2.6/net/ipv4/tcp_input.c:2515
> tcp_fastretrans_alert+0xa5/0xa4f()

You seem to be good in catching these... :-)


-- 
 i.
--=_courier-8386-1204138613-0001-2--
