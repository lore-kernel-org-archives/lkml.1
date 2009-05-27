Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbZE0Urq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbZE0Urq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZE0UrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:47:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbZE0UrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:47:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2 bugs related to suspend to disk
Date: Wed, 27 May 2009 22:47:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <4A199A7A.3010705@gmail.com> <200905252331.02488.rjw@sisk.pl> <4A1D9A4C.4000600@gmail.com>
In-Reply-To: <4A1D9A4C.4000600@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905272247.29098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009, Marcin Slusarz wrote:
> Rafael J. Wysocki wrote
> > On Monday 25 May 2009, Marcin Slusarz wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Sunday 24 May 2009, Marcin Slusarz wrote:
> >>>> Pavel Machek wrote:
> >>>>> Hi!
> >>>>>
> >>>>>
> >>>>>> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
> >>>>>>
> >>>>> I'm afraid we need more details here. Is "resume" binary being ran?
> >>>> Excellent question ;) - I didn't know it has to. I'll try to setup
> >>>> initramfs tomorrow.
> >>>>
> >>>> Thanks and sorry for the noise!
> >>> However, the issue reported as 1) is not really a noise IMO. :-)
> >>>
> >>> Can you please attach a full dmesg output containing these messages?
> >> I've uploaded .config, dmesg (BUG was not saved) and 2 pictures of
> >> screen just before power loss to http://www.kadu.net/~joi/kernel/2009.05.25/
> >> (Please ignore first suspend failure (3681.078646 - 3685.514358) - I forgot
> >> to restore swap)
> > 
> > Thanks.
> > 
> > Can you please test the patch sent by Sebastian Ott in this thread?
> 
> BUG disappeared with this patch.

Thanks for testing.

> Is this a final fix?

I'm not sure yet.

Best,
Rafael
