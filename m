Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0CDWuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:50:13 -0500
Received: from tundra.namei.org ([65.99.196.166]:51300 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0CDWuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:50:11 -0500
Date: Fri, 5 Mar 2010 09:49:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH 1/2] Security: Fix some coding styles in
 security/keys/keyring.c
In-Reply-To: <20100304132623.GA3740@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1003050949350.8114@tundra.namei.org>
References: <20100304132623.GA3740@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, wzt.wzt@gmail.com wrote:

> Fix some coding styles in security/keys/keyring.c
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue

Note, there seems to be no patch 2/2.


> 
> ---
>  security/keys/keyring.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 8ec0274..d77a7ef 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -168,12 +168,10 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
>  {
>  	struct keyring_list *klist;
>  
> -	if (keyring->description) {
> +	if (keyring->description)
>  		seq_puts(m, keyring->description);
> -	}
> -	else {
> +	else
>  		seq_puts(m, "[anon]");
> -	}
>  
>  	rcu_read_lock();
>  	klist = rcu_dereference(keyring->payload.subscriptions);
> -- 
> 1.6.5.3
> 

-- 
James Morris
<jmorris@namei.org>
