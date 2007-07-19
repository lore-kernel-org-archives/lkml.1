Return-Path: <linux-kernel-owner+w=401wt.eu-S939769AbXGSQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939769AbXGSQtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbXGSQtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:49:03 -0400
Received: from il.qumranet.com ([82.166.9.18]:54593 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935902AbXGSQtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:49:00 -0400
Message-ID: <469F9603.8050603@qumranet.com>
Date: Thu, 19 Jul 2007 19:49:07 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<ukleinek@informatik.uni-freiburg.de>,
       Jens Axboe <axboe@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@linux.ie>,
       =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@tungstengraphics.com>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>,
       Charles Gagalac <charles.gagalac@gmail.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
References: <469F92A1.5070203@googlemail.com>
In-Reply-To: <469F92A1.5070203@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
>
> Unclassified
>
> Subject         : a52b1752c07 broke !SMP: error: implicit declaration of function `WARN_ON'
> References      : http://lkml.org/lkml/2007/7/17/600
> Last known good : ?
> Submitter       : Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
> Caused-By       : Avi Kivity <avi@qumranet.com>
>                   commit a52b1752c077cb919b71167c54968a0b91673281
> Handled-By      : ?
> Status          : unknown
>   

This has been fixed by Al Viro, 
8dfd588c3180b7403c402b4545164ee4543f8f86, in mainline.

I am now working on kvm and slub intensely disliking each other.

Note: the wiki page is immutable, so I could not update it.

-- 
error compiling committee.c: too many arguments to function

