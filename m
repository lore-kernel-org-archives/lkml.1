Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYHUBtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYHUBtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 21:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHUBtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 21:49:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48633 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYHUBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 21:49:12 -0400
Subject: Re: CONFIG_KMOD breakage in next kernel
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <1219257889.3502.13.camel@johannes.berg>
References: <s5h3akzwtki.wl%tiwai@suse.de>
	 <1219252617.7591.350.camel@violet.holtmann.net>
	 <1219257889.3502.13.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 03:49:17 +0200
Message-Id: <1219283357.7591.370.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> > > I found that CONFIG_KMOD was already removed in linux-next tree.
> > > This seems to result in many breakages.  For example, I cannot mount a
> > > FAT device automatically because of failure of automatic loading of
> > > nls modules.
> > > 
> > > My particular problem would be fixed by the patch below, but I found
> > > CONFIG_KMOD is still referred in many places.
> > 
> > I am happy to fix the net/bluetooth/ part, you someone has to put out a
> > guideline how this should be fixed.
> 
> Bluetooth was already part of http://lkml.org/lkml/2008/7/9/144
> 
> Basically, I got rid of CONFIG_KMOD, always enabling it when
> CONFIG_MODULES is defined and making it a dummy no-op inline when not.

I missed the patches, but that happens from time to time. Just looked at
them and they look pretty nice. I like it this way.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


