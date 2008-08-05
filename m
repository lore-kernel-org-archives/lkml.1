Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYHEPmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYHEPmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYHEPmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:42:46 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39971 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbYHEPmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:42:45 -0400
Date: Tue, 5 Aug 2008 18:41:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v4l/mips build problem
Message-ID: <20080805154122.GC22895@cs181140183.pp.htv.fi>
References: <20080806012357.55625daf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080806012357.55625daf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 01:23:57AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Linus' current tree gets the following error during a mips allmodconfig
> build:
> 
> drivers/media/video/vino.c:4364: error: implicit declaration of function `video_usercopy'

Andrew fixed it with drivers-media-video-vinoc-needs-v4l2-ioctlh.patch 
in -mm.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

