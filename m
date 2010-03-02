Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0CBWRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:17:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:57717 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab0CBWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:17:06 -0500
Date: Wed, 3 Mar 2010 09:17:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: Re: [PATCH] Security: Add __init to register_security to disable
 load a security module on runtime
In-Reply-To: <20100226144955.GB2778@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1003030916460.14492@tundra.namei.org>
References: <20100226144955.GB2778@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, wzt.wzt@gmail.com wrote:

> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue


> ---
>  security/security.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/security.c b/security/security.c
> index 122b748..7da630a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -110,7 +110,7 @@ int __init security_module_enable(struct security_operations *ops)
>   * If there is already a security module registered with the kernel,
>   * an error will be returned.  Otherwise %0 is returned on success.
>   */
> -int register_security(struct security_operations *ops)
> +int __init register_security(struct security_operations *ops)
>  {
>  	if (verify(ops)) {
>  		printk(KERN_DEBUG "%s could not verify "
> -- 
> 1.6.5.3
> 

-- 
James Morris
<jmorris@namei.org>
