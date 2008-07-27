Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYG0Qhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYG0Qhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYG0Qhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:37:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:39819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYG0Qhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:37:31 -0400
Date: Sun, 27 Jul 2008 18:37:26 +0200
From: Karsten Keil <kkeil@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Karsten Keil <kkeil@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Add mISDN driver
Message-ID: <20080727163726.GA13004@pingi.kke.suse.de>
References: <20080727010837.GA3415@pingi.kke.suse.de> <20080727064327.GA10804@elte.hu> <20080727064452.GA11129@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727064452.GA11129@elte.hu>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 08:44:52AM +0200, Ingo Molnar wrote:
> 
> ( Please dont use Mail-Followup-To! It messed up replies _big_
>   time. Mail repeated below.)

OK, hopefully it is disabled now.

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Karsten Keil <kkeil@suse.de> wrote:
> > 
> > > Please pull this and the following patches from 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> > > 
> > > mISDN is a new modular ISDN driver, in the long term it should replace 
> > > the old I4L driver architecture for passiv ISDN cards.
> > 
> > -tip testing found that the build broke due to these changes:
> > 
> >  drivers/isdn/hisax/built-in.o: In function `release_tei':
> >  (.text+0x29da): multiple definition of `release_tei'
> >  drivers/isdn/mISDN/built-in.o:(.text+0x8e80): first defined here
> > 

Grumble, I thought I already catched this some days ago, but seems I forgot
to commit it. Will have a patch soon.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
