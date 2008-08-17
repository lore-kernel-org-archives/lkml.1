Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYHQMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYHQMp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYHQMpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:45:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:52173 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbYHQMpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:45:09 -0400
Date: Sun, 17 Aug 2008 22:43:33 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>, morgan@kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] security.h: fix build failure 
In-Reply-To: <20080817013420.GA7622@orion>
Message-ID: <alpine.LRH.1.10.0808172242480.13264@tundra.namei.org>
References: <20080817013420.GA7622@orion>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, Alexander Beregalov wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> security.h: fix build failure
> 
> include/linux/security.h: In function 'security_ptrace_traceme':
> include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)
> 
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: James Morris <jmorris@namei.org>


> ---
> 
>  include/linux/security.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 2ee5ecf..80c4d00 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1755,7 +1755,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
>  	return cap_ptrace_may_access(child, mode);
>  }
>  
> -static inline int security_ptrace_traceme(struct task_struct *child)
> +static inline int security_ptrace_traceme(struct task_struct *parent)
>  {
>  	return cap_ptrace_traceme(parent);
>  }
> 

-- 
James Morris
<jmorris@namei.org>
