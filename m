Return-Path: <linux-kernel-owner+w=401wt.eu-S940371AbXGSRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940371AbXGSRFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938451AbXGSRFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:05:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:7241 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbXGSRFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nzniYyYLK41vSMKGTppteUSu+r00enRGWiMlxWj1lx6j5DSzeZEdENa5IamjaG2iiqfoo1TI+a9P8gQ7qe0yx183nWY92oD8KWfrnupy8HKi/VhMKYD8wvXM5WoJgHBwilV2/pO4SkCRwk/DB1I/yER4YvJYYsSbFmeoozxXTkA=
Message-ID: <a781481a0707191005n6657251ah7ac4e078a4e628c1@mail.gmail.com>
Date: Thu, 19 Jul 2007 22:35:18 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>,
       "Tejun Heo" <htejun@gmail.com>, "Avi Kivity" <avi@qumranet.com>,
       "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" 
	<ukleinek@informatik.uni-freiburg.de>,
       "Jens Axboe" <axboe@suse.de>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       dri-devel@lists.sourceforge.net, "Dave Airlie" <airlied@linux.ie>,
       "=?ISO-8859-1?Q?Michel_D=E4nzer?=" <michel@tungstengraphics.com>,
       "=?ISO-8859-1?Q?Kristian_H=F8gsberg?=" <krh@redhat.com>,
       "Charles Gagalac" <charles.gagalac@gmail.com>
In-Reply-To: <469F92A1.5070203@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F92A1.5070203@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject         : Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
> References      : http://lkml.org/lkml/2007/7/19/202
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : Jeremy Fitzhardinge <jeremy@xensource.com>
>                   commit c70df74376c1e29a04e07e23dd3f4c384d6166dd
> Handled-By      : ?
> Status          : unknown

Fixed by Jeremy Fitzhardinge, see:

http://lkml.org/lkml/2007/7/18/410

Dunno if it's in latest git.

> Subject         : Oops while modprobing phy fixed module
> References      : http://lkml.org/lkml/2007/7/14/63
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : Tejun Heo <htejun@gmail.com>
>                   commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
> Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
>                   Tejun Heo <htejun@gmail.com>
> Status          : unknown


This thread consisted of two unrelated/different oops stack traces :-)

One of them was fixed by Tejun,
a1da4dfe35bc36c3bc9716d995c85b7983c38a76

The other is SLUB related, I think.

> Block layer
>
> Subject         : broken {sd,hd}parm
> References      : http://lkml.org/lkml/2007/7/16/389
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : ?
> Handled-By      : FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Status          : problem is being debugged

James Bottomley posted a patch for it just now, Gabriel seems
to be happy with it
