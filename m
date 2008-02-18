Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYBRSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYBRSGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbYBRSFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:05:51 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54736 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbYBRSFt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:05:49 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow check
In-Reply-To: Your message of "Mon, 18 Feb 2008 18:22:05 +0800."
             <47B95C4D.6080000@cn.fujitsu.com>
From: Valdis.Kletnieks@vt.edu
References: <47B95C4D.6080000@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203357921_2991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 13:05:21 -0500
Message-ID: <26325.1203357921@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203357921_2991P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Feb 2008 18:22:05 +0800, Shi Weihua said:

> -	/*
> -	 * If we are on the alternate signal stack and would overflow it, don't.
                                                                   notice this ^
> -	 * Return an always-bogus address instead so we will die with SIGSEGV.

> +			 * If we are on the alternate signal stack and would
> +			 * overflow it, don't return an always-bogus address
                                missing here ^
> +			 * instead so we will die with SIGSEGV.

"don't. Return" is a vastly different semantic than "don't return".

I think the same comment error was cut-n-pasted into all 5 patches...


--==_Exmh_1203357921_2991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHucjhcC3lWbTT17ARArK3AKDsUVaff1ksVsc6KV1ystchRPwIFwCfWWig
uShQ4rEY47CS1CGkSAVja0k=
=Au2F
-----END PGP SIGNATURE-----

--==_Exmh_1203357921_2991P--
