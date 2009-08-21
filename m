Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbZHUOib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbZHUOib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZHUOib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:38:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44885 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbZHUOia (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:38:30 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/15] x86, sched: Add config option for multi-node CPU scheduling
In-Reply-To: Your message of "Thu, 20 Aug 2009 15:15:21 +0200."
             <20090820131521.GP29327@alberich.amd.com>
From: Valdis.Kletnieks@vt.edu
References: <20090820131243.GO29327@alberich.amd.com>
            <20090820131521.GP29327@alberich.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1250862635_55673P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 09:50:35 -0400
Message-ID: <57214.1250862635@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1250862635_55673P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Aug 2009 15:15:21 +0200, Andreas Herrmann said:
> 
> I've decided to add this as a subitem of MC scheduling.
> I think the normal case will be that a multi-node CPU has more than 1
> core on each of its nodes. Thus using MN scheduling without MC
> scheduling does not make much sense.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

Is this patch series bisectable? I admit not having checked deeply, and
at least at first glance the rest looks sane - but usually Kconfig changes
are kept until the *last* patch so that there's no chance of inter-patch
dependencies breaking...

--==_Exmh_1250862635_55673P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKjqYrcC3lWbTT17ARAoSsAKDzmwQYjWEDwSotXTbqhya6YtZnUACgy9ye
crfKLPc4vpDnARAmLGmGxtU=
=oaJu
-----END PGP SIGNATURE-----

--==_Exmh_1250862635_55673P--
