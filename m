Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbZE1JjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbZE1JjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZE1Jiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:38:52 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35755 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZE1Jiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:38:51 -0400
X-Auth-Info: Mt1tUG3kWlq1mxeKfOcgAE+fFD5cjySp09fcTjJjPm4=
To: Robert Schwebel <r.schwebel@pengutronix.de>
cc: Scott Wood <scottwood@freescale.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <20090528000707.GR6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de>
Comments: In-reply-to Robert Schwebel <r.schwebel@pengutronix.de>
   message dated "Thu, 28 May 2009 02:07:07 +0200."
Date: Thu, 28 May 2009 11:38:48 +0200
Message-Id: <20090528093848.B048A832E416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Robert Schwebel,

In message <20090528000707.GR6805@pengutronix.de> you wrote:
>
> Until now, oftree has created more problems than it has solved for us.
> The idea works fine for well-known things like memory maps and
> interrupts. It works badly for corner cases, and embedded land is full
> of it. The effort to get the oftree stuff right is often more than a
> magnitude of order higher than the effort for the actual functionality.

Well, but isn't this also because the device tree dramatically
reduced the amount of effort to get a new board supported? We have
seen a number of cases where _only_ the device tree needed
significant efforts to get a basic BSP running on a new board.
Talking about ration of device tree efforts versus code writing
efforts is somewhat irrelevant when you ignore that the total effort
goes down. Sometimes significantly.

> That should be an alarm sign that something is wrong.

Maybe the interpretation of data?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
If programming was easy, they wouldn't need something as  complicated
as a human being to do it, now would they?
                       - L. Wall & R. L. Schwartz, _Programming Perl_
