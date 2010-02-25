Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab0BYPZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:25:55 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58313 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0BYPZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:25:54 -0500
Date: Thu, 25 Feb 2010 10:26:09 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
 kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-
 and-resolve-limit.cleanup
Message-ID: <20100225152609.GC2990@shamino.rdu.redhat.com>
References: <20100225150826.GA22440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225150826.GA22440@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -3.9 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 04:08:26PM +0100, Oleg Nesterov wrote:
> Trivial, kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
> forgot to kill the declaration of call_usermodehelper_stdinpipe() which no
> longer exists.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
> --- mm/include/linux/kmod.h~0_KILL_DECL	2010-02-25 15:57:02.000000000 +0100
> +++ mm/include/linux/kmod.h	2010-02-25 15:58:20.000000000 +0100
> @@ -73,8 +73,6 @@ struct subprocess_info *call_usermodehel
>  /* Set various pieces of state into the subprocess_info structure */
>  void call_usermodehelper_setkeys(struct subprocess_info *info,
>  				 struct key *session_keyring);
> -int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
> -				  struct file **filp);
>  void call_usermodehelper_setfns(struct subprocess_info *info,
>  		    int (*init)(struct subprocess_info *info),
>  		    void (*cleanup)(struct subprocess_info *info),
> 
> 
Thanks, Oleg!

Acked-by: Neil Horman <nhorman@tuxdriver.com>
