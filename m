Return-Path: <linux-kernel-owner+w=401wt.eu-S1764469AbZFQHYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764469AbZFQHYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFQHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:24:03 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:57498 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZFQHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:24:02 -0400
Date: Wed, 17 Jun 2009 09:23:50 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] s390: remove DEBUG_MALLOC
Message-ID: <20090617092350.7a391ad5@skybase>
In-Reply-To: <Pine.LNX.4.64.0906170941340.29445@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906170941340.29445@melkki.cs.Helsinki.FI>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 09:42:38 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> The kernel now has kmemleak and kmemtrace so there's no reason to keep
> this ugly s390 hack around. I am not sure how it's supposed to work on
> SMP anyway as it uses a global variable to temporarily store the return 
> value of all kmalloc() calls:
> 
>   void *b;
> 
>   #define kmalloc(x...) (PRINT_INFO(" kmalloc %p\n",b=kmalloc(x)),b)

Ouch! Yes, we better remove this quickly before anybody else sees it.
I'll add it to git390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

