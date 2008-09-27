Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYI0E1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYI0E1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYI0E1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:27:09 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:56561 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYI0E1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:27:08 -0400
Message-ID: <48DDB5F6.107@kernel.org>
Date: Fri, 26 Sep 2008 21:26:30 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/6] file capabilities: uninline cap_safe_nice
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
In-Reply-To: <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Serge E. Hallyn wrote:
> This reduces the kernel size by 289 bytes.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

> ---
>  security/commoncap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 9bfef94..d48fdd8 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -512,7 +512,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
>   * yet with increased caps.
>   * So we check for increased caps on the target process.
>   */
> -static inline int cap_safe_nice(struct task_struct *p)
> +static int cap_safe_nice(struct task_struct *p)
>  {
>  	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
>  	    !capable(CAP_SYS_NICE))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI3bX0+bHCR3gb8jsRApVqAKCuFmvJTlIiAYxXW5W3JNncFYmmrQCfa95h
Ik/MLVnpPtZdmuInkJSOof4=
=3aYe
-----END PGP SIGNATURE-----
