Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYG0GpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYG0GpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYG0GpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:45:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35811 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYG0GpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:45:05 -0400
Date: Sun, 27 Jul 2008 08:44:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Add mISDN driver
Message-ID: <20080727064452.GA11129@elte.hu>
References: <20080727010837.GA3415@pingi.kke.suse.de> <20080727064327.GA10804@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727064327.GA10804@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Please dont use Mail-Followup-To! It messed up replies _big_
  time. Mail repeated below.)

* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Karsten Keil <kkeil@suse.de> wrote:
> 
> > Please pull this and the following patches from 
> > git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> > 
> > mISDN is a new modular ISDN driver, in the long term it should replace 
> > the old I4L driver architecture for passiv ISDN cards.
> 
> -tip testing found that the build broke due to these changes:
> 
>  drivers/isdn/hisax/built-in.o: In function `release_tei':
>  (.text+0x29da): multiple definition of `release_tei'
>  drivers/isdn/mISDN/built-in.o:(.text+0x8e80): first defined here
> 
> with this config:
> 
>  http://redhat.com/~mingo/misc/config-Sun_Jul_27_08_30_16_CEST_2008.bad
> 
> 	Ingo
