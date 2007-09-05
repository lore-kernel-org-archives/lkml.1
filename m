Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXIET1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXIET1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbXIET1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:27:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60080 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756422AbXIET1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:27:17 -0400
Date: Wed, 5 Sep 2007 21:27:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
Message-ID: <20070905192719.GH16016@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200709051443.21522.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 02:43:21PM +0100, Denys Vlasenko wrote:

> Build system: section garbage collection for vmlinux
> 
> Newer gcc and binutils can do dead code and data removal
> at link time. It is achieved using combination of
> -ffunction-sections -fdata-sections options for gcc and
> --gc-sections for ld.
>...

In the long term I'd like us to be able to compile the whole (or at 
least most of) the kernel with one "-combine -fwhole-program" gcc call 
which should bring the same positive effect plus enables gcc to do 
additional optimizations.

That's meant as a remark, not against your patch (which is for a lower 
hanging fruit).

> vda

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

