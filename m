Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbXK2Cuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbXK2Cuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbXK2Cuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:50:44 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35728 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbXK2Cun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:50:43 -0500
Date: Wed, 28 Nov 2007 20:50:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] (2.4.26-rc3-mm2) -mm Update CAP_LAST_CAP to reflect
	CAP_MAC_ADMIN
Message-ID: <20071129025039.GA31726@sergelap.austin.ibm.com>
References: <474E0749.9080305@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474E0749.9080305@schaufler-ca.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Bump the value of CAP_LAST_CAP to reflect the current last cap value.
> It appears that the patch that introduced CAP_LAST_CAP and the patch
> that introduced CAP_MAC_ADMIN came in more or less at the same time.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Signed-off-by: Serge Hallyn <serue@us.ibm.com>


> 
> ---
> 
>  include/linux/capability.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/include/linux/capability.h linux-2.6.24-rc3-mm2-lastcap/include/linux/capability.h
> --- linux-2.6.24-rc3-mm2-base/include/linux/capability.h	2007-11-27 16:47:02.000000000 -0800
> +++ linux-2.6.24-rc3-mm2-lastcap/include/linux/capability.h	2007-11-28 14:04:57.000000000 -0800
> @@ -315,10 +315,6 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_SETFCAP	     31
> 
> -#define CAP_LAST_CAP         CAP_SETFCAP
> -
> -#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
> -
>  /* Override MAC access.
>     The base kernel enforces no MAC policy.
>     An LSM may enforce a MAC policy, and if it does and it chooses
> @@ -336,6 +332,10 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_MAC_ADMIN        33
> 
> +#define CAP_LAST_CAP         CAP_MAC_ADMIN
> +
> +#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
> +
>  /*
>   * Bit location of each capability (used by user-space library and kernel)
>   */
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
