Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0BYDAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:00:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:55142 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab0BYDAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:00:18 -0500
Message-ID: <4B85E9E6.9050306@kernel.org>
Date: Thu, 25 Feb 2010 12:09:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] workqueues: s/2/WORK_STRUCT_STATIC/ in	WORK_DATA_STATIC_INIT()
References: <20100224202038.GA26998@redhat.com>
In-Reply-To: <20100224202038.GA26998@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 02:59:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/25/2010 05:20 AM, Oleg Nesterov wrote:
> Cosmetic. Don't hide WORK_STRUCT_STATIC from grep.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  include/linux/workqueue.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wq/include/linux/workqueue.h~3_STATIC_INIT_USE_STATIC	2010-02-24 20:33:43.000000000 +0100
> +++ wq/include/linux/workqueue.h	2010-02-24 21:01:20.000000000 +0100
> @@ -36,7 +36,7 @@ struct work_struct {
>  };
>  
>  #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
> -#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
> +#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(1UL << WORK_STRUCT_STATIC)

I already have this in my cmwq patches.

Thanks.

-- 
tejun
