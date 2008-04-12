Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYDLPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYDLPUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYDLPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:20:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:31202 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYDLPU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m17UcUHlLHB4WzHpATwPulkIybANv6IPMPGZ/BwhvdCp7AfCdoiizEUNbf7UA6HgFOtFCBkvLaWaKMH9ldFWfWzF7KdENT+bJMYl7+LQIIUnS7t76LcuP9f4qYf2yjOOlcR9FuavBpSG0cj0JRsKz2Y7xqx0bG0RCJWJ0FFwnwA=
Message-ID: <170fa0d20804120820x1eced1ebl47b6a2f6593ea029@mail.gmail.com>
Date: Sat, 12 Apr 2008 11:20:28 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: Western Digital GreenPower drives and Linux
Cc: devzero@web.de, lkml@metanurb.dk, pernegger@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <200804120811.12468.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <234148243@web.de> <200804112200.28854.tvrtko@ursulin.net>
	 <170fa0d20804112019h73928c99paadcc363539fea9c@mail.gmail.com>
	 <200804120811.12468.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 3:11 AM, Tvrtko A. Ursulin <tvrtko@ursulin.net> wrote:
> On Saturday 12 April 2008 04:19:33 Mike Snitzer wrote:
>  > Any chance you could make your iso available for the freedos w/
>  > wdidle3.exe bootable cd?
>  >
>  > I can't track down wdidle3.exe on wdc.com; they have "Data Lifeguard"
>  > and such but I have no idea if the wdidle3.exe is buried in those
>  > downloads.
>
>  According to the licence which comes with that thing distribution is not
>  allowed. Also it wouldn't be bad if more people contacted WD about it so that
>  they figure out they at least need to make it available as a download, if not
>  something better.

Just an FYI, I had a look at my counters for a 1TB GP I've had in
always-on service (expansion drive for my tivo; which runs Linux) for
6 months.  I'm not seeing any issues, Load_Cycle_Count is quite low.

Device Model:     WDC WD10EACS-32ZJB0
Firmware Version: 01.01B01

   9 Power_On_Hours          0x0032   094   094   000    Old_age
Always       -       4763
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       7
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       9

Given the Tivo is constantly doing IO it must've prevented the disk
from ever spinning down.
