Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXE3Oah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXE3Oah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXE3Oaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:30:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38801 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXE3Oa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:30:29 -0400
Date: Wed, 30 May 2007 16:30:08 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - cleanup of debug code (was Re: 2.6.22-rc2-mm1)
In-Reply-To: <d120d5000705300727g7ddfb845sa02ad92a434aefc6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705301628360.10318@twin.jikos.cz>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> 
 <1179962229.8575.4.camel@localhost>  <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
  <200705232328.42657.dtor@insightbb.com>  <Pine.LNX.4.64.0705301603200.10318@twin.jikos.cz>
 <d120d5000705300727g7ddfb845sa02ad92a434aefc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Dmitry Torokhov wrote:

> I'd rather leave it as is in case someone wants to squeeze last bit of 
> memory savings from the kernel. 

Yup, that's why I left CONFIG_HID_DEBUG still in place to let users that 
care that much to turn in off.

> Also there some security issues (someone breaking into the box and 
> enabling i8042 debug and capturing all keycodes) so uber-sensitive folks 
> can use it to disable debug completely.

Well this doesn't seem to an issue at all to me - if someone breaks into 
the box, he has dozens of other possibilities how to capture the 
keystrokes than enabling i8042 debug.

Thanks,

-- 
Jiri Kosina
