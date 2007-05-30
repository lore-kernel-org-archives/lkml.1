Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXE3Dui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXE3Dui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 23:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXE3Dub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 23:50:31 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:37367 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXE3Dua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 23:50:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMwAJKQXEZKhRO4UWdsb2JhbACHLYhHARwNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
Date: Tue, 29 May 2007 23:17:11 -0400
User-Agent: KMail/1.9.3
Cc: Jan Kratochvil <honza@jikos.cz>, linux-kernel@vger.kernel.org
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz> <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz> <1180474885.5822.94.camel@localhost.localdomain>
In-Reply-To: <1180474885.5822.94.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705292317.14023.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2007 17:41, Richard Purdie wrote:
> On Tue, 2007-05-29 at 23:29 +0200, Jan Kratochvil wrote:
> >    I have question, probably for Richard. Why is 
> > /sys/class/leds/whatsoever/brightness mode set to 0644? Is it really necessary?
> > I feel like I'll be happy to allow anybody to change the state of this led. (Ok 
> > this maybe doesn't apply to other leds)
> 
> Permissions management of the LEDs is outside the scope of kernel. If
> you need users to have access to them, change the permissions in
> userspace to grant access.
> 

I will also venture to say that you only want to grant access to
the user currently logged on console, not any random user logged
in over the network so you really want to dynamically manage
premissions. The kernel just provides sensible defaults.

-- 
Dmitry
