Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXGJD6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXGJD6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXGJD6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:58:11 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33646 "EHLO
	asav14.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbXGJD6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:58:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgeAASgkkZKhRO4R2dsb2JhbACHJogDAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Date: Mon, 9 Jul 2007 23:58:07 -0400
User-Agent: KMail/1.9.3
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Riepe <michael@mr511.de>,
       Henrique de Moraes Holschuh <hmh@debian.org>
References: <200705252354.43730.dtor@insightbb.com> <200707090144.45557.dtor@insightbb.com> <41840b750707082306n6509ee6ds3a0ccd16b6387353@mail.gmail.com>
In-Reply-To: <41840b750707082306n6509ee6ds3a0ccd16b6387353@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707092358.08529.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 02:06, Shem Multinymous wrote:
> > > > Have 2nd input device's ->open() method call input_open_device() for
> > > > the first one.
> > >
> > > Won't that create an overhead by the redundant, unused notifications?
> >
> > They won't leave input core so nothing really noticeable.
> 
> Sounds good, then. It's a bit of a hack, but the benefits are well
> worth it (if we can resolve the scheduling issue).
>

You know, I slept on it and I think I want to move the polldev into
opposite direction - to accomodte devices that need "relaxed" polling
and are ok with polling being a bit irregular and maybe even rounded
to next jiffy or something to better accomodate tickless kernels.

So I guess it would be better to drop my hdaps patch after all. 

-- 
Dmitry
