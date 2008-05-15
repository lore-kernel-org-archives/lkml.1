Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYEOAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYEOAvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYEOAvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:51:43 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:33501 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYEOAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:51:42 -0400
Date: Wed, 14 May 2008 17:51:40 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Adrian Bunk <bunk@kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes for 2.6.26
In-Reply-To: <20080514193822.GA21795@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.58.0805141749470.23876@shell4.speakeasy.net>
References: <20080514114910.4bcfd220@gaivota> <20080514165434.GC22115@cs181133002.pp.htv.fi>
 <20080514145554.10e3385c@gaivota> <20080514193822.GA21795@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Adrian Bunk wrote:
> > It would be nice if you could help on fixing those issues.
> >
> > One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
> > I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).
>
> What about converting all dependencies on I2C to select's?

Doesn't that just increase the problems with failing to have correct
dependencies?  Anything that selects I2C needs to depend on everything I2C
depends on.
