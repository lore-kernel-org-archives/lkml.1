Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbYD3I2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbYD3I2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbYD3I2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:28:12 -0400
Received: from znsun1.ifh.de ([141.34.1.16]:47365 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbYD3I2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:28:10 -0400
X-Greylist: delayed 1398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 04:28:07 EDT
Date: Wed, 30 Apr 2008 10:02:43 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
X-X-Sender: pboettch@pub4.ifh.de
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes
 for 2.6.26
In-Reply-To: <20080429185009.716c3284@gaivota>
Message-ID: <Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
References: <20080429185009.716c3284@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

sorry to say that now and not earlier, but:

On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:
> .../{dvb/frontends => common/tuners}/mt2266.c      |    0
> .../{dvb/frontends => common/tuners}/mt2266.h      |    4 +-

The mt2266 is a zero-IF (baseband) tuner. I think there is no analog 
decoder for this kind of tuners.

Maybe the move was not necessary, but maybe all tuners should go to 
common.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
