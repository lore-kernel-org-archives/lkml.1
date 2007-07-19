Return-Path: <linux-kernel-owner+w=401wt.eu-S937605AbXGSSze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937605AbXGSSze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXGSSzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:55:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:59963 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXGSSzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nN22fSSSW0TNHQNveM42JLV5eEjTS0TXE9d1ZB9Ij7TEleMCKVGBiuCdsIvsS9HT4cNptADOshNjbe2qhf2HQH61ylUWJpjPJU8BYafgus8NY/jw46bji4Z0zqvBN8nEjOENttJEACHb3aCC5mzD5xMKBfsdqyu2zX6e7sXpYe4=
Message-ID: <a781481a0707191155p4aa962dcqd31d9a894ca44fde@mail.gmail.com>
Date: Fri, 20 Jul 2007 00:25:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <469FAFF7.6050801@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F92A1.5070203@googlemail.com>
	 <a781481a0707191005n6657251ah7ac4e078a4e628c1@mail.gmail.com>
	 <469F9C3B.3040503@googlemail.com> <469FAFF7.6050801@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Gabriel C wrote:
> >>
> >>
> >>> Subject         : Oops while modprobing phy fixed module
> >>> References      : http://lkml.org/lkml/2007/7/14/63
> >>> Last known good : ?
> >>> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> >>> Caused-By       : Tejun Heo <htejun@gmail.com>
> >>>                   commit 3007e997de91ec59af39a3f9c91595b31ae6e08b
> >>> Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
> >>>                   Tejun Heo <htejun@gmail.com>
> >>> Status          : unknown
> >>>
> >>>
> >> This thread consisted of two unrelated/different oops stack traces :-)
> >>
> >> One of them was fixed by Tejun,
> >> a1da4dfe35bc36c3bc9716d995c85b7983c38a76
> >>
> >> The other is SLUB related, I think.
> >>
> >>
> >>
> >
> > Yes SLAB/SLUB traces.
> >
> > I will test the SLAB fix ( noone told me is fixed ) and I'll test the
> > same with SLUB to see whatever is fixed in current git , later.
> >
> >
> >
>
> Both looks fixed on current git head I cannot reproduce the Oops'es
> anymore here.
>
> Just the phy fixed driver is still broken.


http://lkml.org/lkml/2007/7/18/506
