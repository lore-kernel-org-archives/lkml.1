Return-Path: <linux-kernel-owner+w=401wt.eu-S1762341AbYF0VHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341AbYF0VHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764120AbYF0VG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:06:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58251 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764115AbYF0VG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:06:57 -0400
Date: Fri, 27 Jun 2008 16:06:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] security: filesystem capabilities no longer
	experimental
Message-ID: <20080627210656.GD17415@us.ibm.com>
References: <4863584A.9030301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863584A.9030301@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> It is time to drop the experimental tag.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFIY1hK+bHCR3gb8jsRAnl4AKDBkfuW/XfiCIPcoVX3FIT6Ctl0cACbBfH4
> pGbRuQD7OLrALAk4WLr/rB8=
> =GZsK
> -----END PGP SIGNATURE-----

> From 4eefa8e670c4fa4c1c4454302f585eef9f46b74b Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Wed, 25 Jun 2008 23:33:11 -0700
> Subject: [PATCH] Filesystem capabilities have come of age.
> 
> Remove the experimental tag for configuring filesystem capabilities.
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  security/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 49b51f9..9d5b806 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -82,8 +82,8 @@ config SECURITY_CAPABILITIES
>  	  If you are unsure how to answer this question, answer Y.
>  
>  config SECURITY_FILE_CAPABILITIES
> -	bool "File POSIX Capabilities (EXPERIMENTAL)"
> -	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
> +	bool "File POSIX Capabilities"
> +	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
>  	default n
>  	help
>  	  This enables filesystem capabilities, allowing you to give
> -- 
> 1.5.3.7
> 

