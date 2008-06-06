Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYFFFuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYFFFuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYFFFub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:50:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:47399 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751692AbYFFFua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:50:30 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/t3DZkU8Ht3K+mGbIHPJjzWfrHnK+roWA/UNW3id
	kkfpZArGbdr+Ic
Date: Fri, 6 Jun 2008 07:50:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <200806052229.37143.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0806060744450.14536@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
 <200806052229.37143.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 5 Jun 2008, David Brownell wrote:

> On Monday 02 June 2008, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > as far as I understand, the current GPIO API only presents very basic GPIO 
> > functionality: direction and level reading and writing. Whereas many GPIO 
> > controllers have many further configurable parameters: pull-ups and 
> > pull-downs, drive strength, slew rate, etc.
> 
> Not at all how I'd describe it.  Those omitted mechanisms are part
> of pin configuration, in the same way as function multiplexing is.
> (That is, assigning a given pin for use as a GPIO, vs hooking it up
> to an I2C, MMC, SPI, LCD, I2S, or memory controller.)
> 
> Those mechanisms are highly chip-specific.  Far more so than simple
> boolean GPIO mechanisms.  With rare exceptions, they're needed only
> in platform-specific board setup code, which is already accessing
> lots of platform-specific programming interfaces.  I'm really not
> keen on having them become part of the GPIO framework.  The thought
> makes me think of trying to swallow a kitchen sink; sorry ...

Thanks for the lengthy explanation with numerous examples - this is 
appreciated. But I'll omit that for this reply. Just a short question so 
far - how would you handle an external GPIO expander with an additional 
functionality, naimly, a possibility to switch pull-ups to GPIO pins, 
specifically, it defines 4 modes for a pin: out high, out low, in without 
a pullup and in with a pullup. And if the user application wants to decide 
at run-time which pull-ups to switch and when? It's a MAX7301 from Maxim 
btw.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
