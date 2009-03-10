Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZCJTyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZCJTyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZCJTyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:54:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:29717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZCJTyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,337,1233561600"; 
   d="scan'208";a="496688615"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Stoyan Gaydarov <stoyboyker@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Tue, 10 Mar 2009 12:54:33 -0700
Subject: RE: [PATCH 03/25] [net] BUG to BUG_ON changes
Thread-Topic: [PATCH 03/25] [net] BUG to BUG_ON changes
Thread-Index: AcmhPucW/8gZlShnSBeIS6J0AdEZ/wAergfA
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A1E7589DC@orsmsx507.amr.corp.intel.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
In-Reply-To: <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stoyan Gaydarov wrote:
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/net/atl1e/atl1e_main.c    |    3 +--
>  drivers/net/chelsio/sge.c         |    3 +--
>  drivers/net/ixgb/ixgb_osdep.h     |    2 +-
>  drivers/net/pppol2tp.c            |    3 +--
>  drivers/net/wireless/ath9k/core.h |    6 +-----
>  5 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ixgb/ixgb_osdep.h
> b/drivers/net/ixgb/ixgb_osdep.h 
> index d92e72b..371a6be 100644
> --- a/drivers/net/ixgb/ixgb_osdep.h
> +++ b/drivers/net/ixgb/ixgb_osdep.h
> @@ -40,7 +40,7 @@
>  #include <linux/sched.h>
> 
>  #undef ASSERT
> -#define ASSERT(x)	if (!(x)) BUG()
> +#define ASSERT(x)	BUG_ON(!(x))
>  #define MSGOUT(S, A, B)	printk(KERN_DEBUG S "\n", A, B)
> 
>  #ifdef DBG

ack the ixgb portion

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
