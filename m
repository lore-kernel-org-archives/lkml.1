Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbZHDSqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbZHDSqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbZHDSqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:46:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60170 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbZHDSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:46:30 -0400
Date: Tue, 4 Aug 2009 13:46:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 6/6] KEYS: Do some whitespace cleanups
Message-ID: <20090804184618.GD8442@us.ibm.com>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145556.17676.80359.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804145556.17676.80359.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Do some whitespace cleanups in the key management code.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

(trivially correct of course)

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  security/keys/proc.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/security/keys/proc.c b/security/keys/proc.c
> index 643ecf0..e4fde23 100644
> --- a/security/keys/proc.c
> +++ b/security/keys/proc.c
> @@ -194,11 +194,9 @@ static int proc_keys_show(struct seq_file *m, void *v)
>  	/* come up with a suitable timeout value */
>  	if (key->expiry == 0) {
>  		memcpy(xbuf, "perm", 5);
> -	}
> -	else if (now.tv_sec >= key->expiry) {
> +	} else if (now.tv_sec >= key->expiry) {
>  		memcpy(xbuf, "expd", 5);
> -	}
> -	else {
> +	} else {
>  		timo = key->expiry - now.tv_sec;
> 
>  		if (timo < 60)
> @@ -238,9 +236,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
>  	seq_putc(m, '\n');
> 
>  	rcu_read_unlock();
> -
>  	return 0;
> -
>  }
> 
>  #endif /* CONFIG_KEYS_DEBUG_PROC_KEYS */
> @@ -266,6 +262,7 @@ static struct rb_node *key_user_first(struct rb_root *r)
>  	struct rb_node *n = rb_first(r);
>  	return __key_user_next(n);
>  }
> +
>  /*****************************************************************************/
>  /*
>   * implement "/proc/key-users" to provides a list of the key users
> @@ -273,7 +270,6 @@ static struct rb_node *key_user_first(struct rb_root *r)
>  static int proc_key_users_open(struct inode *inode, struct file *file)
>  {
>  	return seq_open(file, &proc_key_users_ops);
> -
>  }
> 
>  static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
> @@ -290,14 +286,12 @@ static void *proc_key_users_start(struct seq_file *p, loff_t *_pos)
>  	}
> 
>  	return _p;
> -
>  }
> 
>  static void *proc_key_users_next(struct seq_file *p, void *v, loff_t *_pos)
>  {
>  	(*_pos)++;
>  	return key_user_next((struct rb_node *) v);
> -
>  }
> 
>  static void proc_key_users_stop(struct seq_file *p, void *v)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
