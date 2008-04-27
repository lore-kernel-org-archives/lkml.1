Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYD0V0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYD0V0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYD0V0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:26:34 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:59174 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYD0V0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:26:33 -0400
Message-ID: <4814EF74.4050508@kernel.org>
Date: Sun, 27 Apr 2008 14:26:12 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] capabilities: implement per-process securebits
References: <47BA3E21.2020303@kernel.org> <20080426081810.7f1245e7.akpm@linux-foundation.org>
In-Reply-To: <20080426081810.7f1245e7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

OK. Thanks.

Cheers

Andrew

Andrew Morton wrote:
| On Mon, 18 Feb 2008 18:25:37 -0800 "Andrew G. Morgan"
<morgan@kernel.org> wrote:
|
|> Here is the patch to add per-process securebits again. This version
|> includes Serge's argument type fix (thanks), but is otherwise unchanged
|> from the one posted a couple of weeks back. It is against Linus' tree as
|> of a the 15th.
|
| The hitherto-invisible-to-me PR_GET_TSC and PR_SET_TSC have turned up in
| mainline, so I have renumbered your prctl options to
|
| /* Get/set securebits (as per security/commoncap.c) */
| #define PR_GET_SECUREBITS 27
| #define PR_SET_SECUREBITS 28
|
| --
| To unsubscribe from this list: send the line "unsubscribe
linux-security-module" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIFO9x+bHCR3gb8jsRAqgmAJ4zd97eTDcB0r9ipPvli23KYFuEmACgmSzu
x0njikL5e+gf6//Raac3qY0=
=xc7N
-----END PGP SIGNATURE-----
