Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZCNLSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZCNLSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZCNLRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:17:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:36123 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZCNLRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ax84/bLslbU0NATZWbxnJgr9C82LT5pyy/ayUtRb9as2ercwXyY47DPWD8FNyJeZ8g
         yia0FAy/usNKDowOOYrQe1T1L9dETt5Cw6u19Hax51SUUvt8QYRpS2KaCuhCwEyJTH43
         J2bL6TAZz7C+smRlAB2eZgihnLZASr/Et/VyI=
MIME-Version: 1.0
In-Reply-To: <20090313173353.10169.23515.stgit@warthog.procyon.org.uk>
References: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
	 <20090313173353.10169.23515.stgit@warthog.procyon.org.uk>
Date: Sat, 14 Mar 2009 20:17:40 +0900
X-Google-Sender-Auth: 07b565ea9ad856e5
Message-ID: <2f11576a0903140417p390e15e6o316916c764a16616@mail.gmail.com>
Subject: Re: [PATCH 2/2] NOMMU: Make CONFIG_UNEVICTABLE_LRU available when 
	CONFIG_MMU=n
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: minchan.kim@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8c89597..b53427a 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -206,7 +206,6 @@ config VIRT_TO_BUS
>  config UNEVICTABLE_LRU
>        bool "Add LRU list to track non-evictable pages"
>        default y
> -       depends on MMU
>        help
>          Keeps unevictable pages off of the active and inactive pageout
>          lists, so kswapd will not waste CPU time or have its balancing

   Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
