Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXFCFHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXFCFHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 01:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXFCFHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 01:07:40 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:60074 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXFCFHj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 01:07:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] xt_u32 - match arbitrary bits and bytes of a packet
In-Reply-To: Your message of "Sat, 02 Jun 2007 23:46:46 +0200."
             <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180847247_3873P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 03 Jun 2007 01:07:27 -0400
Message-ID: <18087.1180847247@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180847247_3873P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 23:46:46 +0200, Jan Engelhardt said:

> along comes xt_u32, a revamped ipt_u32,

+1 for doing this - I've been dragging along a local ipt_u32 patch for a while,
and been wishing it had ipv6 support.

>     *	Reduced the buffer size to 17 KB. I think that is quite ok since 
> 	I added an overflow check,  SHOULD THERE BE ANY device with an 
> 	MTU larger than our loopback masterpiece (16436 bytes).
> 
> 	Are there such devices that support Megasuperjumboframes?

IP over Infiniband? I think those have some outrageous MTU?  Personally,
I wouldn't need it for anything bigger than 9K ethernet jumbograms, but
that one's a decision for others.


--==_Exmh_1180847247_3873P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYkyPcC3lWbTT17ARAgUrAJ9uKK1dIGLxjHTLVbINo5VkfBb/4wCfVpIM
KWETgfVCEUrItMy08VcThOc=
=XZFc
-----END PGP SIGNATURE-----

--==_Exmh_1180847247_3873P--
