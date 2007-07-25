Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXGYVCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXGYVCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765572AbXGYVC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:02:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44356 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764859AbXGYVCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:02:25 -0400
Date: Wed, 25 Jul 2007 23:01:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, takata@linux-m32r.org
Cc: linux-kernel@vger.kernel.org, linux-m32r@ml.linux-m32r.org
Subject: 2.6.23-rc1-mm1: m32r is_init() compile error
Message-ID: <20070725210157.GH3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +pid-namespaces-define-is_global_init-and-is_container_init.patch
>...
>  pid namespaces
>...

m32r was forgotten:

<--  snip  -->

...
  CC      arch/m32r/mm/fault.o
arch/m32r/mm/fault.c: In function 'do_page_fault':
arch/m32r/mm/fault.c:274: error: implicit declaration of function 'is_init'
make[2]: *** [arch/m32r/mm/fault.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

