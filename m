Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbYD3TEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbYD3TEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763624AbYD3TE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:04:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851AbYD3TE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:04:26 -0400
Date: Wed, 30 Apr 2008 16:03:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes
 for 2.6.26
Message-ID: <20080430160354.29dfe255@gaivota>
In-Reply-To: <Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
References: <20080429185009.716c3284@gaivota>
	<Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick

On Wed, 30 Apr 2008 10:02:43 +0200 (CEST)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> Hi Mauro,
> 
> sorry to say that now and not earlier, but:
> 
> On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:
> > .../{dvb/frontends => common/tuners}/mt2266.c      |    0
> > .../{dvb/frontends => common/tuners}/mt2266.h      |    4 +-
> 
> The mt2266 is a zero-IF (baseband) tuner. I think there is no analog 
> decoder for this kind of tuners.

Ah, ok. I'm not 100% sure, but I think some chips, like cx88 could theoretically
support a baseband tuner. But you're right: there's no known board using mt2266. 

> Maybe the move was not necessary, but maybe all tuners should go to 
> common.

Good point. 

It seems easier to maintain if we should move all terrestrial/cable [1]
(analog and/or digital) tuners into common/tuners. 

Cheers,
Mauro


[1] I don't see any technical sense of moving satellite tuners, except for
having just one place for all tuners, or if there are some tendency of hybrid
satellite/terrestrial tuners.
