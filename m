Return-Path: <linux-kernel-owner+w=401wt.eu-S2993355AbXEBPXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993355AbXEBPXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993356AbXEBPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:23:00 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:22197 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993355AbXEBPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:23:00 -0400
Date: Wed, 2 May 2007 16:22:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
cc: Phillip Susi <psusi@cfl.rr.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
In-Reply-To: <20070502143839.GA31961@atjola.homenet>
Message-ID: <Pine.LNX.4.64.0705021616260.31229@blonde.wat.veritas.com>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
 <20070502143839.GA31961@atjola.homenet>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-159877230-1178119363=:31229"
X-OriginalArrivalTime: 02 May 2007 15:22:56.0641 (UTC) FILETIME=[C2B89710:01C78CCD]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAQi5TdGVpbmJyaW5rQGdteC5kZQBwc3VzaUBjZmwucnIuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-159877230-1178119363=:31229
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 2 May 2007, Bj=C3=B6rn Steinbrink wrote:
> On 2007.05.02 15:04:44 +0100, Hugh Dickins wrote:
> > On Tue, 1 May 2007, Phillip Susi wrote:
> > > I seem to remember seeing some patches go by at some point that
> > > allowed one of the rom type embeded system filesystems to directly
> > > execute binaries out of the original rom memory rather than copying
> > > them to ram first, then executing from there.  I was wondering if
> > > rootfs or tmpfs support such execute in place today, or if binaries
> > > executed from there have their code segments duplicated in ram?
> >=20
> > Only ext2 supports it today: see Documentation/filesystems/xip.txt
>=20
> As I understand it, xip avoids the page cache copy. But tmpfs already
> lives in the page cache (or swap), so avoiding that "copy" is
> impossible. But I always expected tmpfs to implicitly due its own kind
> of xip, i.e. that it doesn't have to store its stuff in the page cache
> twice. Are you saying that this isn't true?

tmpfs doesn't store its stuff in the page cache twice: that's true,
and I didn't mean to imply otherwise.  But tmpfs doesn't contain any
support for rom memory: you'd have to copy from rom to tmpfs to use it.

Hugh
--8323584-159877230-1178119363=:31229--
