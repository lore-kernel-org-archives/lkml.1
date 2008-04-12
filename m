Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYDLP41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYDLP41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYDLP4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:56:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:15710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYDLP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UEcJYrm7FPHtzcHvDOzAp4wnQ2THwuHe9aeXhIvALviU/Ib6ZwRa4lsH6S6QveitccWFciCNMZMN1pWlSQU6MA71yGhLZ93vzatVoXZhsHchYqUPntJURSHM7CRXzHm1clWq6YHJNKgDCLj4P+x3fIRj7r168PBVwlCeEAKaDWc=
Message-ID: <170fa0d20804120856w786b625cv41af33072605dab7@mail.gmail.com>
Date: Sat, 12 Apr 2008 11:56:02 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: Western Digital GreenPower drives and Linux
Cc: devzero@web.de, lkml@metanurb.dk, pernegger@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <170fa0d20804120820x1eced1ebl47b6a2f6593ea029@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <234148243@web.de> <200804112200.28854.tvrtko@ursulin.net>
	 <170fa0d20804112019h73928c99paadcc363539fea9c@mail.gmail.com>
	 <200804120811.12468.tvrtko@ursulin.net>
	 <170fa0d20804120820x1eced1ebl47b6a2f6593ea029@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 11:20 AM, Mike Snitzer <snitzer@gmail.com> wrote:
>
> On Sat, Apr 12, 2008 at 3:11 AM, Tvrtko A. Ursulin <tvrtko@ursulin.net> wrote:
>  > On Saturday 12 April 2008 04:19:33 Mike Snitzer wrote:
>  >  > Any chance you could make your iso available for the freedos w/
>  >  > wdidle3.exe bootable cd?
>  >  >
>  >  > I can't track down wdidle3.exe on wdc.com; they have "Data Lifeguard"
>  >  > and such but I have no idea if the wdidle3.exe is buried in those
>  >  > downloads.
>  >
>  >  According to the licence which comes with that thing distribution is not
>  >  allowed. Also it wouldn't be bad if more people contacted WD about it so that
>  >  they figure out they at least need to make it available as a download, if not
>  >  something better.
>
>  Just an FYI, I had a look at my counters for a 1TB GP I've had in
>  always-on service (expansion drive for my tivo; which runs Linux) for
>  6 months.  I'm not seeing any issues, Load_Cycle_Count is quite low.
>
>  Device Model:     WDC WD10EACS-32ZJB0
>  Firmware Version: 01.01B01
>
>    9 Power_On_Hours          0x0032   094   094   000    Old_age
>  Always       -       4763
>   12 Power_Cycle_Count       0x0032   100   100   000    Old_age
>  Always       -       7
>  193 Load_Cycle_Count        0x0032   200   200   000    Old_age
>  Always       -       9
>
>  Given the Tivo is constantly doing IO it must've prevented the disk
>  from ever spinning down.

Turns out 'wdidle3 /R' on my drive reported:
"Idle3 Timer is disabled"

I took no explicit action to disable it 6 months ago. It strikes me as
odd that WD would disable the Idle3 timer in firmware given the whole
"GreenPower" campaign but I was pleasantly surprised; others may be
too...
