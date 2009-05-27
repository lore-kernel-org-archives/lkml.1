Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZE0Ihp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZE0Ihp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZE0Ihi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:37:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:37926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbZE0Ihh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:37:37 -0400
Subject: Re: [PATCH -tip] Documentation/connector/cn_test.c remove unused
 cn_test_want_notify()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
In-Reply-To: <1242805348.3260.52.camel@localhost.localdomain>
References: <1242797693.3260.15.camel@localhost.localdomain>
	 <20090520072224.GA19823@ioremap.net>
	 <1242805348.3260.52.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 27 May 2009 14:07:12 +0530
Message-Id: <1243413432.3109.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

If you want, you can also apply this patch along with another
Documentation patch.

And also add ACK from Evgeniy Polyakov <zbr@ioremap.net>

Thanks,
--
JSR

On Wed, 2009-05-20 at 13:12 +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-05-20 at 11:22 +0400, Evgeniy Polyakov wrote:
> > On Wed, May 20, 2009 at 11:04:53AM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> > > 
> > > Currently cn_test_want_notify() is not having any user.
> > 
> > Do not remove it, disable with ifdef if you want, it is an example
> > of how to get notifications about new connector user registration.
> > 
> 
> [PATCH -tip] Documentation/connector/cn_test.c comment unused cn_test_want_notify()
> 
> Currently cn_test_want_notify() is not having any user.
> 
> So adding ifdef and comment which tells to not remove it.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  Documentation/connector/cn_test.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
> index 6977c17..f688eba 100644
> --- a/Documentation/connector/cn_test.c
> +++ b/Documentation/connector/cn_test.c
> @@ -41,6 +41,12 @@ void cn_test_callback(void *data)
>  	       msg->seq, msg->ack, msg->len, (char *)msg->data);
>  }
>  
> +/*
> + * Do not remove this function even if no one is using it as
> + * this is an example of how to get notifications about new
> + * connector user registration
> + */
> +#if 0
>  static int cn_test_want_notify(void)
>  {
>  	struct cn_ctl_msg *ctl;
> @@ -117,6 +123,7 @@ nlmsg_failure:
>  	kfree_skb(skb);
>  	return -EINVAL;
>  }
> +#endif
>  
>  static u32 cn_test_timer_counter;
>  static void cn_test_timer_func(unsigned long __data)

