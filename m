Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYDENYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYDENYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYDENYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:24:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:11948 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYDENYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=I0a+K4g9Lm4RjKqjAuwz9hF87rfkg/IS5N9TRf/89wb2/9a1TcPI8ZthZUWwrS+AsrJoZU2CRFwHUtgJcDeQ0FxO19wn9yRhUXSPQ1duX5d2w5JWM3XaP0pcqPHimoGS2MdHea0Cur5FYSCtjNdfdOUXlmG9gCXV6ctq+Xzj634=
Message-ID: <6101e8c40804050624u4b902096q867f231f8aa13d1c@mail.gmail.com>
Date: Sat, 5 Apr 2008 15:24:13 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [OP] linux v2.6.22.21-op1
In-Reply-To: <6101e8c40804050622k18fde2f5p73c42d27a3189fe3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8828_3148634.1207401854026"
References: <6101e8c40804050622k18fde2f5p73c42d27a3189fe3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8828_3148634.1207401854026
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

and the patch

On 4/5/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> I announced the v2.6.22.21-op1 "stable" kernel.
>
> gitweb: http://repo.or.cz/w/linux-2.6.22.y-op.git
>  git-tree: git://repo.or.cz/linux-2.6.22.y-op.git
>  patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
>  tar-bz2:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.21-op1.tar.bz2
>  patch:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2
>  chlog:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.21-op1
>  ======================================
>
>  Makefile                       |    2 +-
>  drivers/md/raid5.c             |   14 ++---
>  drivers/net/tulip/tulip_core.c |    4 +
>  fs/cifs/cifs_debug.c           |   92 +++--------------------------
>  fs/cifs/cifsglob.h             |   11 ++++
>  fs/cifs/cifsproto.h            |    4 +-
>  fs/cifs/cifssmb.c              |  130
> ++++++++++++++++++----------------------
>  fs/cifs/connect.c              |    9 ++-
>  fs/cifs/file.c                 |   14 ++--
>  fs/cifs/sess.c                 |    3 +-
>  fs/cifs/transport.c            |   88 +++++++++++++++++++++------
>  mm/slab.c                      |    5 +-
>  12 files changed, 174 insertions(+), 202 deletions(-)
>
>  ======================================
> gitweb: http://repo.or.cz/w/linux-2.6.22.y-op.git
>  git-tree: git://repo.or.cz/linux-2.6.22.y-op.git
>  patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
>  tar-bz2:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.21-op1.tar.bz2
>  patch:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2
>  chlog:
> http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.21-op1
>  ======================================
>
>  Makefile                       |    2 +-
>  drivers/md/raid5.c             |   14 ++---
>  drivers/net/tulip/tulip_core.c |    4 +
>  fs/cifs/cifs_debug.c           |   92 +++--------------------------
>  fs/cifs/cifsglob.h             |   11 ++++
>  fs/cifs/cifsproto.h            |    4 +-
>  fs/cifs/cifssmb.c              |  130
> ++++++++++++++++++----------------------
>  fs/cifs/connect.c              |    9 ++-
>  fs/cifs/file.c                 |   14 ++--
>  fs/cifs/sess.c                 |    3 +-
>  fs/cifs/transport.c            |   88 +++++++++++++++++++++------
>  mm/slab.c                      |    5 +-
>  12 files changed, 174 insertions(+), 202 deletions(-)
>
>  ======================================
>
> Joe Korty (1):
>       slab: NUMA slab allocator migration bugfix
>
> NeilBrown (1):
>       md: fix an occasional deadlock in raid5
>
> Oliver Pinter (1):
>       v2.6.22.21-op1
>
> Steve French (2):
>       Fix buffer overflow if server sends corrupt response to small
>       Fix sign mount option and sign proc config setting
>
> andrew.patterson@hp.com (1):
>       MCA when shutting down tulip quad-NIC
>
> ======================================
>  Thanks,
>  Oliver
>  /* http://students.zipernowsky.hu/~oliverp/ */
>


-- 
Thanks,
Oliver

------=_Part_8828_3148634.1207401854026
Content-Type: application/x-bzip2;
 name=patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2

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
------=_Part_8828_3148634.1207401854026--
