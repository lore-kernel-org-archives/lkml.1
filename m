Return-Path: <linux-kernel-owner+w=401wt.eu-S933095AbXIFVxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbXIFVxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932944AbXIFVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:53:28 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51776 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbXIFVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:53:27 -0400
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] ELAN U132 Host Controller Driver: convert sw_lock to mutex
In-Reply-To: <20070906211815.GD3081@traven>
References: <20070906210922.GC3081@traven> <20070906211815.GD3081@traven>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Fri, 7 Sep 2007 00:08:34 +0200
Message-Id: <E1ITPWc-0004rC-Kr@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thu, 6 Sep 2007 23:18:15 +0200

[]
> @@ -184,7 +184,7 @@ struct u132_ring {
>  struct u132 {

Subject: [PATCH 1/2] ELAN U132 Host Controller Driver: convert sw_lock to mutex
[]
>          struct list_head u132_list;
> -        struct semaphore sw_lock;
> +        struct mutex sw_lock;
>          struct semaphore scheduler_lock;

Subject: [PATCH 2/2] ELAN U132 Host Controller Driver: convert  scheduler_lock t
[]
>         struct list_head u132_list;
>         struct semaphore sw_lock;
>-        struct semaphore scheduler_lock;
>+        struct mutex scheduler_lock;

Are you sure, you have right patch sequence?
____
