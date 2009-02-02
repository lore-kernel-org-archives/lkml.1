Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZBBT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZBBT6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZBBT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:58:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:48533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZBBT57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:57:59 -0500
Message-ID: <49874FE2.6030800@suse.com>
Date: Mon, 02 Feb 2009 14:56:18 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] increment hpilo version
References: <20090123142529.GA5298@ldl.fc.hp.com>
In-Reply-To: <20090123142529.GA5298@ldl.fc.hp.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

David Altobelli wrote:
> Bump hpilo module version to indicate that the open/close bug is fixed.

Hi David -

Was the open/close bug fixed in a differently than with your patch in
"[PATCH] hpilo open/close fix" ? If not, the fix didn't make it into
mainline, but this version bump did.

- -Jeff

> Please CC me on any replies.
> 
> Signed-off-by: David Altobelli <david.altobelli@hp.com>
> ---
> 
> --- drivers/misc/hpilo.c.orig	2009-01-23 08:16:46.000000000 -0600
> +++ drivers/misc/hpilo.c	2009-01-23 08:16:58.000000000 -0600
> @@ -758,7 +758,7 @@ static void __exit ilo_exit(void)
>  	class_destroy(ilo_class);
>  }
>  
> -MODULE_VERSION("0.05");
> +MODULE_VERSION("0.06");
>  MODULE_ALIAS(ILO_NAME);
>  MODULE_DESCRIPTION(ILO_NAME);
>  MODULE_AUTHOR("David Altobelli <david.altobelli@hp.com>");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkmHT+IACgkQLPWxlyuTD7L4GQCggTyIseN8XKJyJMcls8tctJFc
zaoAnA6piyJzdsjHNzKNMY3V4vyjtuES
=Klfx
-----END PGP SIGNATURE-----
