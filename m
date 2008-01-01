Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYAAXPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYAAXPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYAAXPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:15:37 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47189 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYAAXPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:15:36 -0500
Date: Wed, 2 Jan 2008 01:15:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Pinter =?utf-8?B?KFBpbnTDqXIgT2xpdsOpcik=?= 
	<oliver.pntr@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] OSS msnd: fix array overflows
Message-ID: <20080101231521.GG27566@does.not.exist>
References: <20080101134921.GQ2360@does.not.exist> <6101e8c40801011043k209e1db6t1f5877b1c034c865@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6101e8c40801011043k209e1db6t1f5877b1c034c865@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 07:43:23PM +0100, Oliver Pinter (Pintér Olivér) wrote:
> then it is auch to 2.6.22-stable?

That's a very old bug in a driver for ancient hardware, so there's no 
need to hurry.

> On 1/1/08, Adrian Bunk <bunk@kernel.org> wrote:
> > This patch fixes array overflows in the OSS msnd driver spotted by the
> > Coverity checker.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> >
> > This patch has been sent on:
> > - 27 Oct 2007
> >
> > 97463a59dfb9ccb915d3b615225c98cb3e310c0a
> > diff --git a/sound/oss/msnd.h b/sound/oss/msnd.h
> > index 05cf786..d0ca582 100644
> > --- a/sound/oss/msnd.h
> > +++ b/sound/oss/msnd.h
> > @@ -233,8 +233,8 @@ typedef struct multisound_dev {
> >  	spinlock_t lock;
> >  	int nresets;
> >  	unsigned long recsrc;
> > -	int left_levels[16];
> > -	int right_levels[16];
> > +	int left_levels[32];
> > +	int right_levels[32];
> >  	int mixer_mod_count;
> >  	int calibrate_signal;
> >  	int play_sample_size, play_sample_rate, play_channels;
> 
> Thanks,
> Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

