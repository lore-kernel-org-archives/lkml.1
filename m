Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0CHQDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:03:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:30384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0CHQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=syBeXfhlirnhWfE2mZLb7nNahcOT5IWJSCz4gVD7Tty7wl6gcMJzLx9Aon2WwdoUUb
         asPu/yixz2C92gIcpqVf60+GOqmUhFfJwEIxiMRUKEvF7Gj5dyKkTbMBs6qthzrqiTqX
         pOL0Ooe3K4xthkUMUkP3PoRoyKivTtreQ5T5g=
Date: Mon, 8 Mar 2010 19:02:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jason Dreisbach <jtdreisb@gmail.com>
Cc: jt@hp1.hp.com, gregkh@suse.de--to, jpirko@redhat.com,
       linville@tuxdriver.com, jtdreisb@gmail.com--cc,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: wavelan: fix coding style of first 1000 lines
	in wavelan.c
Message-ID: <20100308160250.GC19256@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jason Dreisbach <jtdreisb@gmail.com>, jt@hp1.hp.com,
	gregkh@suse.de--to, jpirko@redhat.com, linville@tuxdriver.com,
	jtdreisb@gmail.com--cc, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 02:20:30AM -0800, Jason Dreisbach wrote:
> From: Jason <jtdreisb@gmail.com>

>  		/* Check mc_config command */
>  		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
>  			printk(KERN_INFO
> -			       "%s: wv_config_complete(): set_multicast_address failed; status = 0x%x\n",
> +			       "%s: wv_config_complete(): \
> +			       set_multicast_address failed; status = 0x%x\n",
>  			       dev->name, status);
>  

This patch introduces several bugs like the one above.

I know it's depressing to send a patch and have criticized, but besides
this bug which affects users there are some other whitespace changes 
in this patch which are not correct.

If you want to resend this once you fix the errors, feel free, it does 
fix quite a few white space issues.  

But really it's always better to focus on fixing actual bugs.  I know that
Greg says fixing white space is a great way to learn the patch submission
process, but anyone can do that.  The most important thing is to learn how
to fix bugs.  We can deal with malformed patches so long as they fix 
something.

regards,
dan carpenter
