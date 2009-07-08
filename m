Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZGHTcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZGHTcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbZGHTcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:32:36 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44011 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZGHTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:32:36 -0400
Subject: Re: [PATCH 41/44] includecheck fix: include/linux, rfkill.h
From: Marcel Holtmann <marcel@holtmann.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247068554.4382.106.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247068554.4382.106.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 12:32:37 -0700
Message-Id: <1247081557.9709.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

> fix the following 'make includecheck' warning:
> 
>   include/linux/rfkill.h: linux/types.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/rfkill.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index e73e242..2ce2983 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -99,7 +99,6 @@ enum rfkill_user_states {
>  #undef RFKILL_STATE_UNBLOCKED
>  #undef RFKILL_STATE_HARD_BLOCKED
>  
> -#include <linux/types.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>

with the #ifdef __KERNEL__ in between it is kinda weird, but patch seems
correct.

Regards

Marcel


