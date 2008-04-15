Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYDOTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYDOTCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYDOTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:02:24 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48545 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbYDOTCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:02:24 -0400
Date: Tue, 15 Apr 2008 22:01:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: build issue #469 for v2.6.25-rc8-166-g6fdf5e6 in pms.c :
	undefined reference to `video_usercopy'
Message-ID: <20080415190112.GA1677@cs181133002.pp.htv.fi>
References: <200804061448.42888.toralf.foerster@gmx.de> <20080415135933.1a85fd2e@gaivota> <200804151958.39524.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804151958.39524.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:58:39PM +0200, Toralf Förster wrote:
>...
> @@ -60,9 +60,14 @@ config VIDEO_V4L1_COMPAT
> 
>  config VIDEO_V4L2
>         bool
> +       tristate
>         depends on VIDEO_DEV && VIDEO_V4L2_COMMON
>         default VIDEO_DEV && VIDEO_V4L2_COMMON
>...

i don't know whether this gets parsed, but it shouldn't have both "bool" 
and "tristate".

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

