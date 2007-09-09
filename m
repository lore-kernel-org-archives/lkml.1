Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbXIIOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbXIIOVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXIIOVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:21:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46663 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756738AbXIIOVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:21:11 -0400
Date: Sun, 9 Sep 2007 16:21:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] remove asm/bitops.h includes
Message-ID: <20070909142117.GH3563@stusta.de>
References: <30483262301654323266@pripojeni.net> <p738x7gs1rq.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <p738x7gs1rq.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 10:04:25AM +0200, Andi Kleen wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
> 
> > remove asm/bitops.h includes
> > 
> > including asm/bitops directly may cause compile errors. 
> 
> When does it cause compile errors? It would be probably less 
> intrusive to just fix that case.

In -mm, include/asm-generic/bitops/non-atomic.h requires stuff from 
include/linux/bitops.h

And it's generally better to have all users consistently use the linux/ 
headers instead of some using the linux/ headers and some the asm/ 
headers.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

