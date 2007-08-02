Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXHBOJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXHBOJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbXHBOIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:08:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40918 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXHBOIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:08:52 -0400
Date: Thu, 2 Aug 2007 16:08:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bernd Petrovitsch <bernd@firmix.at>
cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] type safe allocator
In-Reply-To: <1186063605.8085.82.camel@tara.firmix.at>
Message-ID: <Pine.LNX.4.64.0708021608010.24572@fbirervta.pbzchgretzou.qr>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> 
 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>  <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
  <1186062476.12034.115.camel@twins> <1186063605.8085.82.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 16:06, Bernd Petrovitsch wrote:
>> thrice in some cases like alloc_struct(struct task_struct, GFP_KERNEL)
>
>Save the explicit "struct" and put it into the macro (and force people
>to not use typedefs).
>
>#define alloc_struct(type, flags) ((type *)kmalloc(sizeof(struct type), (flags)))

#define alloc_struct(type, flags) ((struct type *)kmalloc(sizeof(struct type), (flags)))

>Obious drawback: We may need alloc_union().
>SCNR.

And we still don't have something to allocate a bunch of ints.
[kmalloc(sizeof(int)*5,GFP)]


	Jan
-- 
