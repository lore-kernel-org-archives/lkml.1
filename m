Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbYKEXK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbYKEXK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYKEXKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:10:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbYKEXKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:10:39 -0500
Date: Wed, 05 Nov 2008 15:10:15 -0800 (PST)
Message-Id: <20081105.151015.206163697.davem@davemloft.net>
To: swmike@swm.pp.se
Cc: daniel.blueman@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	<alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Abrahamsson <swmike@swm.pp.se>
Date: Wed, 5 Nov 2008 23:20:25 +0100 (CET)

> So the upside of enabling it is minimal (I'd gladly see data proving
> the opposite) and the downside is a lot of trouble with lots of
> older devices which behave badly when ECN is enabled.

This kind of thinking just perpetuates the problem forever.

If nothing important on end nodes enables it by default, people
running core routers have no reason to turn it on, and so on and so
forth.

Linux is much bigger and smarter than that, so we should break
the loop and enable it by default some point soon.
