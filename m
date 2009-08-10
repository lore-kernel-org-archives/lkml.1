Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZHJPAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZHJPAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZHJPAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:00:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52824 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZHJPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:00:20 -0400
Date: Mon, 10 Aug 2009 17:00:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: power_supply class/framework question
Message-ID: <20090810150011.GA1471@ucw.cz>
References: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (feel free to redirect me to a different mailing list if there's a
> more appropriate place to ask this question)
> 
> I'm working on cleaning up some code to more correctly use the power
> supply framework (have the battery driver receive notification from
> the wall/usb power supplies, etc), and ran into a slight snag.  For
> mobile usb powered devices, we need to know how much current can
> safely be consumed by the charge circuit -- generally this is one of:
> none, <500mA or 1000mA, which correspond to "no power supply", "usb
> power supply", or "wall power supply".

Actuallly, it is one of 'none', 100mA (min power USB has to supplly),
500mA (max powe USB can supply by spec), 1A (wall).

For example sharp zaurus can only supply cca 300mA out of its port.

> I can use power_supply_am_i_supplied() to determine if I'm receiving
> power, but there's no way to determine either how much (if I have one
> power supply that indicates max current available) or which supply (if
> I define a separate "ac" and "usb" power supply).

Should am_i_supplied() just return miliamps?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
