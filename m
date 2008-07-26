Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbYGZI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbYGZI3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 04:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYGZI3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 04:29:13 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:51563 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGZI3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 04:29:12 -0400
Date: Sat, 26 Jul 2008 01:26:01 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [RFC PATCH] of_gpio: implement of_get_gpio_flags()
In-Reply-To: <20080725164815.GA23228@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807260122100.26456@t2.domain.actdsltmp>
References: <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
 <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
 <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
 <20080718100549.GA28741@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp>
 <20080721175357.GA1773@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807211340460.26456@t2.domain.actdsltmp>
 <20080723145650.GA13792@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807231551230.26456@t2.domain.actdsltmp>
 <20080725164815.GA23228@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, Anton Vorontsov wrote:
>
> The name seems a bit unfortunate though, because one could read the
> function as it gets gpio flags only (though, we might implement
> this instead, but this way average driver will end up with parsing
> gpios = <> twice).

It is kind of a confusing name.  I'd be tempted to just change of_get_gpio,
it's a new function and it's only called from four places so it's not that
hard to change.
