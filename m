Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYCaB1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYCaB1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 21:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYCaB07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 21:26:59 -0400
Received: from namei.org ([69.55.235.186]:41534 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbYCaB07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 21:26:59 -0400
Date: Mon, 31 Mar 2008 12:26:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Adrian Bunk <bunk@kernel.org>
cc: sds@tycho.nsa.gov, eparis@parisplace.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] selinux/ss/services.c should #include <linux/selinux.h>
In-Reply-To: <20080330225402.GM28445@cs181133002.pp.htv.fi>
Message-ID: <Xine.LNX.4.64.0803311226081.11733@us.intercode.com.au>
References: <20080330225402.GM28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Adrian Bunk wrote:

> Every file should include the headers containing the externs for its 
> global code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Thanks, applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm



> ---
> 
> This patch has been sent on:
> - 27 Feb 2008
> 
> eaeb567e2ce03ef3a7c5ed33e35def212ce2899a foobar
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index f374186..29fb216 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -40,6 +40,7 @@
>  #include <linux/sched.h>
>  #include <linux/audit.h>
>  #include <linux/mutex.h>
> +#include <linux/selinux.h>
>  #include <net/netlabel.h>
>  
>  #include "flask.h"
> 

-- 
James Morris
<jmorris@namei.org>
