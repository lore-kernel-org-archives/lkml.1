Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbXLNWAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbXLNWAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXLNV76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:59:58 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:36076 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbXLNV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:59:57 -0500
Date: Fri, 14 Dec 2007 22:59:40 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Message-ID: <20071214215940.GP3851@pengutronix.de>
References: <20071213195617.GF21616@stusta.de> <20071214200318.GM3851@pengutronix.de> <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com> <20071214202829.GN3851@pengutronix.de> <8bd0f97a0712141235h48c3062cl139e4c2883a815a9@mail.gmail.com> <20071214205542.GO3851@pengutronix.de> <8bd0f97a0712141323k7aae718ag4d0fd8a8f13d933f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8bd0f97a0712141323k7aae718ag4d0fd8a8f13d933f@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 22:41:52 up 29 days, 33 min, 10 users,  load average: 0.36, 0.17, 0.11
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: Working upstream toolchain for avr32?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 04:23:12PM -0500, Mike Frysinger wrote:
> > You didn't explain how for example your trunk [1] is related to mainline
> > [2].
>
> nano `find -name ChangeLog.bfin`
>
> read the ChangeLog and the associated commit. this is exactly the
> same way gcc works. you want to know what changed for ChangeLog entry
> $foo, you look at the commit surrounding it.

Well, it's your decision how you think you'd best manage your changes.
It's just an observation that bfin toolchains are a parrallel universe
for community people being used to the "mainline + reviewable patch
sets" paradigm (no, the svn is not reviewable, as it is not regularly
rebased against upstream).

> i dont know what "u-boot-v2" is, but if you're referring to mainline
> u-boot, then it too is not in a usable state.

No need to continue this discussion here. I'll come back with real
questions when re-testing u2 with your "official" toolchains.

> it isnt just random commercial customers as we support anyone using a
> Blackfin (students, hobbyists, whoever). but only if they're using
> the same source base we've tested. once we finish moving things to
> mainline, that will become our source base. until then, it is not
> supportable.

That's all I wanted to hear. As long as you are heading towards getting
the code into gcc.gnu.org, I don't care any more.

> <insert generalities about "big corporations here" and assume everyone
> is the same. it's easier when making assumptions that way!>

Well, chip vendors are usually not that much of a constant as people
from the industry might wish. Strategies change, products are
discontinued, focus changes, companies are sold etc. For industrial
users who go the open source way because of long term product
strategies, having control over the source is pretty important. And
experience shows that once you have problems, the community is a much
better source of help than vendors.

> > Can you explain why bfin should not have gcc.gnu.org as it's upstream?
>
> as you've been told multiple times, that is where we are heading.
> asking the same question multiple times but expecting a different
> response is the definition of madness is it not?

Thanks for clarification. Regarding the original post, it justifies my
assumption that blackfin is currently not supported by upstream gcc.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

