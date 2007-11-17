Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbXKQRZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbXKQRZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbXKQRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:25:08 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60294 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756660AbXKQRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:25:07 -0500
Date: Sat, 17 Nov 2007 18:24:46 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] eradicate bashisms in scripts/patch-kernel
Message-ID: <20071117172446.GD4250@stusta.de>
References: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071031211321.GA8363@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 10:13:21PM +0100, Andreas Mohr wrote:

> Hello,

Hi Andreas,

> I was non-mildly horrified to find that the rather widely used patch-kernel
> script seems to rely on bash despite specifying the interpreter as #!/bin/sh,
> since my dash-using Debian install choked on it.
> 
> Thus I'm delivering a first, preliminary, non-reviewed change to make
> patch-kernel (a little bit more?) POSIX-compatible. It now survives both
> a dash and a bash run.
>...
> Comments?
>...

if that's easyly possible it's OK.

But if it becomes possible I'd strongly favour simply changing the 
interpreter to #!/bin/bash which would also fix this problem.

> Thanks,
> 
> Andreas Mohr
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

