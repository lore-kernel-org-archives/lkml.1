Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXBYDlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXBYDlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 22:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXBYDlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 22:41:45 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:24586 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647AbXBYDlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 22:41:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HABqU4EVKhRO4UGdsb2JhbACHTIdDAQEqk2gBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
Date: Sat, 24 Feb 2007 22:39:32 -0500
User-Agent: KMail/1.9.3
Cc: Richard Knutsson <ricknu-0@student.ltu.se>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
References: <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com> <20070224111124.GB3609@suse.cz> <45E036AB.9050303@student.ltu.se>
In-Reply-To: <45E036AB.9050303@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702242239.33314.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 February 2007 07:59, Richard Knutsson wrote:
> Vojtech Pavlik wrote:
> > On Fri, Feb 23, 2007 at 11:43:44PM +0100, Richard Knutsson wrote:
> >
> >   
> >> Is the reason for the modulo to put a bitmask larger then the variable 
> >> into an array?
> >>     
> >
> > The complementary LONG() macro will tell you the index of an array of
> > longs where the bit should be set.
> >   
> This may be a little OT, but how come it is not done as an function? 
> Maybe something like "(set/get)_long_mask(...)".

We have it. Is is called set_bit (or __set_bit) and works wery well for
single bit operations, but sometimes it is nice to be able to write

	a = BIT(b) | BIT(c); 

-- 
Dmitry
