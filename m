Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbXGLUEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbXGLUEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXGLUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:04:16 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41737 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbXGLUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:04:15 -0400
Date: Thu, 12 Jul 2007 21:03:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Marcos David <marcosgdavid.ml@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/pid/status -> VmLib: 4294948464 kB
In-Reply-To: <2ca024a80707121116i3574e2e2k7783bdb591b571b1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707122056440.6384@blonde.wat.veritas.com>
References: <2ca024a80707121114k530cf0f0wa79d4b40cc1cb375@mail.gmail.com>
 <2ca024a80707121116i3574e2e2k7783bdb591b571b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-721708450-1184270614=:6384"
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAAmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbWFyY29zZ2RhdmlkLm1sQGdtYWlsLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-721708450-1184270614=:6384
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 12 Jul 2007, Marcos David wrote:
> Hi,
> I=C2=B4m using RedHat Enterprise Server 4 Update 3 (kernel 2.6.9-34.ELsmp=
)
>=20
> I was listing the contents of /proc/pid/status file and I came up with
> a value of:
> ...
> VmLib: 4294948464 kB,
> ...
>=20
> Is this a known bug?
> the process in question uses a lot of threads ~100 but there are no
> memory leaks...
>=20
> Any help would be appreciated.

Yes, it's known, I sent two patches to fix it
=09[PATCH] VmLib wrapped: executable brk
=09[PATCH] VmLib wrapped: mprotect flags
on 28 Nov 2004, and those were included in 2.6.10.

It's just an ugliness in the numbers shown, doesn't affect how the
kernel runs: so Red Hat have not bothered to fix it in their update.

Hugh
--8323584-721708450-1184270614=:6384--
