Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXHSUd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXHSUd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbXHSUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:33:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787AbXHSUdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:33:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Date: Sun, 19 Aug 2007 22:42:43 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20070819153259.2c96b904@hyperion.delvare>
In-Reply-To: <20070819153259.2c96b904@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192242.43819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 19 August 2007 15:32, Jean Delvare wrote:
> Hi all, hi Rafael,
> 
> Running kernel 2.6.23-rc3-git1, I noticed yesterday that my CPU (AMD
> Sempron 2600+) was running at a much lower temperature when
> CONFIG_SUSPEND was enabled.

Hm, interesting.

> The temperature difference was quite significant, about 6 degrees Celsius at
> idle. Measuring the power consumption of my system confirmed that the energy
> savings were real: with CONFIG_SUSPEND=n, the system consumes 80 W of power
> (idle), while with CONFIG_SUSPEND=y, the system consumes only 69 W (idle)!
> Can anyone explain how this works?

I can't.

> I didn't expect CONFIG_SUSPEND to make any difference before actually
> switching the system to standby or suspend state.

Yes, that's the expected behavior.

> I tried the same trick on two Intel motherboards I use for testing, but
> this option didn't seem to make any difference in the power consumption
> for these.

Do you have CONFIG_HIBERNATION set?  If not, please see if setting it instead
of CONFIG_SUSPEND leads to the same result on the affected box (ie. running
at lower temperatures).

Greetings,
Rafael
