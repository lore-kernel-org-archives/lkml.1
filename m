Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbZIBKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbZIBKwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZIBKwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:52:22 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:50062 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZIBKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:52:21 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 06:52:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f5G59EX2Kv71ya9B7xeBqOXTT1z5Hb9akDiif6DF5m5QF6/YN6+vqKDgsO2ddnEuQK
         hHxKxQi2hBvV7qsTO1hp3q80ROHcbCdz6GmDp5xoh0oa0w5x90zCa2ROzQSokwxadxrG
         si8QbbUz3yEVehPhbHYjpF433fGIOKROxjVTA=
MIME-Version: 1.0
In-Reply-To: <4A7A0B07.3030503@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
	 <4A716F1C.2050805@mnementh.co.uk>
	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
	 <4A71F2A5.4060206@mnementh.co.uk>
	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
	 <4A787C2C.5070000@mnementh.co.uk>
	 <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
	 <4A7990F6.7030701@mnementh.co.uk> <4A7A0B07.3030503@mnementh.co.uk>
Date: Wed, 2 Sep 2009 19:44:43 +0900
Message-ID: <aec7e5c30909020344l1ec29256g9d6e3cd00a9b520c@mail.gmail.com>
Subject: Re: Example idea for how to solve the clock/cnf problem.
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Thu, Aug 6, 2009 at 7:43 AM, Ian Molton<ian@mnementh.co.uk> wrote:
> Ooops. Patch attached this time.
>
> Please comment on this. (its a WIP remember, so trivial stuff is to be
> ignored - I wanna get the functionality right first.)
>
> Note in particular the change in the suspend/resume paths - we no longer
> (ab)use the enable/disable hooks, which may break some users of the driver.
>
> I havent decided how I'm going to map the conf area in the MFD drivers in a
> nice way yet. As there are no known devices with TWO of these chips in them
> yet, I may do a static one-off mapping for now. At least this will leave
> tmio-mmc.{c,h} pure and free from all CNF area code.

Thanks for your work on this. There is a number of resources check
that is still fixed at 3 instead of 2, but apart from that all is ok
from the SuperH side of things.

In case you missed it, please see my earlier comments and measurements
in this email:

http://lkml.org/lkml/2009/8/18/67

Do you have any updates queued up for this patch, or do you want me to
submit my fix on top of this one?

Cheers,

/ magnus
