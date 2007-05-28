Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXE1Pn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXE1Pn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXE1Pnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:43:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46976 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbXE1Pnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:43:50 -0400
Date: Mon, 28 May 2007 17:43:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 6
Message-ID: <20070528154346.GO3899@stusta.de>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <4cefeab80705280740l36c00bf8t4a6f5b426a7a380a@mail.gmail.com> <200705281049.48679.dhazelton@enter.net> <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cefeab80705280806m39fbcfd6v93a1c847c25e381c@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 08:36:44PM +0530, Nitin Gupta wrote:
>...
> So, before this change, it will be good if it gets merged in mainline
> and tested, at least for correctness, on all supported achs. All the
> while, we will have a good feeling that there is still a good scope
> for perf improvement :)

The correct order is:
- create one version with all the optimizations you have in mind
- then ensure that it works correctly on all architectures and
  document why your version is that much faster than the original 
  version and why you know your optimizations have no side effects
- then get it tested in -mm

After these steps, you can start considering getting it into mainline.

> Cheers,
> Nitin

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

