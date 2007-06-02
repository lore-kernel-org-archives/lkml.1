Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbXFBOny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbXFBOny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbXFBOns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:43:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51698 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759473AbXFBOnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:43:47 -0400
Date: Sat, 2 Jun 2007 16:43:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>
Subject: Re: Conditionals for development tests and output
Message-ID: <20070602144348.GD5500@stusta.de>
References: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:17:53PM -0700, Christoph Lameter wrote:
> This introduces 
> 
> CONFIG_DEVELKERNEL
> 
> If CONFIG_DEVELKERNEL is set then this is a development kernel.
> Otherwise the kernel to be built is a a production kernel.
>...

I have two problems with your patch:

First, there will be a slub/slab specific mechanism for debug code 
controlled by a parameter in the Makefile plus the common 
CONFIG_DEBUG_KERNEL approach used by most other debug options.
We need one approach for all options.

And your approach could easily result in code paths never tested in 
-mm or -rc kernels exploding in the actual release.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

