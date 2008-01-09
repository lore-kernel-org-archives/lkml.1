Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYAIIYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYAIIYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYAIIYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:24:06 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58719 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYAIIYE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:24:04 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, grant@torque.net, tim@cyberelk.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of ioctl
In-Reply-To: Your message of "Wed, 09 Jan 2008 08:06:20 GMT."
             <20080109080620.GE32560@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <4785B7BC.5040106@suse.de>
            <20080109080620.GE32560@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199867034_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 03:23:54 -0500
Message-ID: <23897.1199867034@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199867034_3703P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Jan 2008 08:06:20 GMT, Christoph Hellwig said:

> It's generally considered good style to only have as few as possible
> return values.  And this is especially important when returning from
> a section that's under a lock.  So in this case it would be much better
> if you changes this function to have a local 'int error' variable
> and then just do
> 
> 	error = -EFOO;
> 	goto out_unlock;

I think Christoph meant to say "as few as possible return locations".  One
should write the code to have as many different return values as are
meaningful, but return them from as few places as possible - which is what the
"assign error and goto end" paradigm does...


--==_Exmh_1199867034_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhISacC3lWbTT17ARAreQAKC1hH87AVJtzIIFX3A/LawZijfTFwCcCvav
/wGAhWJlwyqdL1PwEuPnzx0=
=PKCJ
-----END PGP SIGNATURE-----

--==_Exmh_1199867034_3703P--
