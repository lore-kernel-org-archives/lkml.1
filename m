Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXGaJGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXGaJGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXGaJGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:06:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXGaJG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:06:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] Introduce CONFIG_SUSPEND (updated)
Date: Tue, 31 Jul 2007 11:15:27 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292327.19884.rjw@sisk.pl> <200707310059.50329.lenb@kernel.org>
In-Reply-To: <200707310059.50329.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311115.29057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 31 July 2007 06:59, Len Brown wrote:
> On Sunday 29 July 2007 17:27, Rafael J. Wysocki wrote:
> > Still, there are many other files in which CONFIG_PM can be replaced
> > with CONFIG_PM_SLEEP or even with CONFIG_SUSPEND, but they can be updated in
> > the future.
> 
> There is #ifdef CONFIG_PM
> around all the .suspend and .resume methods.
> 
> Technically they are PM_DEVICE_STATES or something,
> that could really be under PM, and both SUSPEND and HIBERNATE
> would depend on PM_DEVICE_STATES, but it is also possible to have
> PM_DEVICE_STATES without SUSPEND and HIBERNATE.

Well, the people on linux-pm seem to agree that the .suspend() and .resume()
callbacks are not suitable for runtime power management, so having them
built without SUSPEND or HIBERNATION wouldn't be very useful. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
