Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXBYDjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXBYDjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 22:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXBYDjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 22:39:46 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:18932 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbXBYDjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 22:39:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HABqU4EVKhRO4UGdsb2JhbACHTIdDAQEqk2gBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
Date: Sat, 24 Feb 2007 22:37:32 -0500
User-Agent: KMail/1.9.3
Cc: Vojtech Pavlik <vojtech@suse.cz>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Milind Choudhary <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
References: <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com> <45DF6E20.9060604@student.ltu.se> <20070224111124.GB3609@suse.cz>
In-Reply-To: <20070224111124.GB3609@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702242237.33182.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 February 2007 06:11, Vojtech Pavlik wrote:
> > The reason I don't like it with modulo is simply because it hides 
> > potential bugs (when x is to big). 
> 
> That would be my only concern - losing compiler warnings.
> 

I think most dangerous scenario is when both shift operands are not constant
but compiler will not help us in this case...
 
-- 
Dmitry
