Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYCBMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYCBMip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 07:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYCBMic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 07:38:32 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48393 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYCBMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 07:38:31 -0500
Date: Sun, 2 Mar 2008 14:38:30 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Guillaume Chazarain <guichaz@gmail.com>
cc: Giangiacomo Mariotti <giangiacomo_mariotti@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:2054 tcp_mark_head_lost()
In-Reply-To: <3d8471ca0803020420ka42319bu1b9888217c869d9d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803021432200.17919@kivilampi-30.cs.helsinki.fi>
References: <858077.97160.qm@web39709.mail.mud.yahoo.com> 
 <20080223000310.4630daa8.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0802271108290.13029@kivilampi-30.cs.helsinki.fi> 
 <3d8471ca0802271056l320a7ee2m5227e114a968d483@mail.gmail.com> 
 <Pine.LNX.4.64.0802272120430.1741@kivilampi-30.cs.helsinki.fi> 
 <Pine.LNX.4.64.0802281018480.32401@kivilampi-30.cs.helsinki.fi>
 <3d8471ca0803020420ka42319bu1b9888217c869d9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-2090882198-1204461510=:17919"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-2090882198-1204461510=:17919
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 2 Mar 2008, Guillaume Chazarain wrote:

> On Thu, Feb 28, 2008 at 9:22 AM, Ilpo Järvinen
<ilpo.jarvinen@helsinki.fi> wrote:
> >  [PATCH] TCP debug S+L (for 2.6.25-rcs, incompatible with 2.6.24.y)
>
> Bittorrenting with this patch applied floods my dmesg. Here is a log 
> dump:
> 
> http://guichaz.free.fr/tcp-debug.log.bz2 (2.3M compressed, 113M 
> uncompressed)

In future, please inline at least the first one of them, if not sure 
where to cut, too much won't hurt... :-)

> It does not contain any "KERNEL: assertion (packets <=
> tp->packets_out) failed at" line, so I'm afraid it's just noise.

At least it catches one bug which could cause that assertion (it is much 
more rigid than the assertion and thus it catched it even though you 
won't see that assertion to ever trigger :-)).

Could you next figure out what is at:
  [<c02e0f83>] tcp_ack+0x621/0xd2f



-- 
 i.
---696243703-2090882198-1204461510=:17919--
