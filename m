Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZDDMXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZDDMXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZDDMXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:23:04 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:35917 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbZDDMXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:23:03 -0400
Date: Sat, 04 Apr 2009 13:20:14 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via  the input layer
Message-ID: <504C2315A8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk> 
 <20090404041813.GA30746@srcf.ucam.org> 
 <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>, Matthew Garrett 
 <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, 
 acpi4asus-user@lists.sourceforge.net, Darren Salt 
 <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-NuLabour-Date: Sat, 8891 Dec 1984 13:20:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Corentin Chary may or may not have written...

>> On the other hand, the default behaviour of the acpi video driver is to
>> change the brightness itself and then also to send the even to
>> userspace, so I guess if it was going to break things it probably would
>> have done already...

> So, I think this patch is ok.

> But there is a thing I don't like is
> int brn = -2;
> brn = notify_brn();
> if (brn != -2)

> How can brn be -2?

If notify_brn() wasn't called, it will be.

> And why -2?

Because notify_brn() won't return it (and if it ever does, it needs to be
fixed). (Yes, I know, "magic numbers" and all that...)

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Lobby friends, family, business, government.    WE'RE KILLING THE PLANET.

Opinions for rent. Reasonable rates.
