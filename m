Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYIZEsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYIZEsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 00:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYIZEsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 00:48:07 -0400
Received: from ozlabs.org ([203.10.76.45]:40915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYIZEsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 00:48:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/6] kmsg: tagged kernel messages.
Date: Fri, 26 Sep 2008 14:48:04 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Joe Perches <joe@perches.com>,
       Tim Hockin <thockin@hockin.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Jochen =?utf-8?q?Vo=C3=9F?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>, Jan Blunck <jblunck@suse.de>,
       Rick Troth <rmt@casita.net>, Utz Bacher <utz.bacher@de.ibm.com>
References: <20080925162827.818261893@de.ibm.com> <20080925163019.210654702@de.ibm.com>
In-Reply-To: <20080925163019.210654702@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261448.05391.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008 02:28:28 Martin Schwidefsky wrote:
> +#define kmsg_emerg(fmt, ...) \
> +	kmsg_printk_hash(KERN_EMERG, fmt, ##__VA_ARGS__)
> +#define kmsg_alert(fmt, ...) \
> +	kmsg_printk_hash(KERN_ALERT, fmt, ##__VA_ARGS__)
> +#define kmsg_crit(fmt, ...) \
> +	kmsg_printk_hash(KERN_CRIT, fmt, ##__VA_ARGS__)
> +#define kmsg_err(fmt, ...) \
> +	kmsg_printk_hash(KERN_ERR, fmt, ##__VA_ARGS__)
> +#define kmsg_warn(fmt, ...) \
> +	kmsg_printk_hash(KERN_WARNING, fmt, ##__VA_ARGS__)
> +#define kmsg_notice(fmt, ...) \
> +	kmsg_printk_hash(KERN_NOTICE, fmt, ##__VA_ARGS__)
> +#define kmsg_info(fmt, ...) \
> +	kmsg_printk_hash(KERN_INFO, fmt, ##__VA_ARGS__)

Now I'm going to be an asshole and ask you to define when each of these levels 
should be used.  Do we need all of them?

Thanks,
Rusty.
