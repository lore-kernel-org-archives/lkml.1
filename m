Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYGAHSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYGAHSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGAHRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:17:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58631 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYGAHRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:17:53 -0400
Date: Tue, 1 Jul 2008 10:17:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -Wmissing-prototypes (was: make foo() static)
Message-ID: <20080701071735.GA17047@cs181140183.pp.htv.fi>
References: <20080630221918.GI1536@cs181140183.pp.htv.fi> <4869D1F3.3030804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4869D1F3.3030804@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:42:59AM +0200, Gerd Hoffmann wrote:
> Adrian Bunk wrote:
> 
> > This patch makes the needlessly global kvm_smp_prepare_boot_cpu() static.
> 
> Hmm, maybe we should build the kernel with -Wmissing-prototypes?
> That should make gcc print a warning for that ...

I started 3 or 4 years ago cleaning up the kernel for 
-Wmissing-prototypes and I'm still working on it.

Many parts of the kernel now compile cleanly or nearly cleanly, but 
looking at e.g. arch/ I know what kind of answers I would get if 
suggesting adding -Wmissing-prototypes today...

> cheers,
>   Gerd

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

