Return-Path: <linux-kernel-owner+w=401wt.eu-S965109AbXCUWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbXCUWAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965116AbXCUWAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:00:40 -0400
Received: from gherkin.frus.com ([192.158.254.49]:55709 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109AbXCUWAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:00:39 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <1174512867.5477.12.camel@localhost.localdomain>
 "from john stultz at Mar 21, 2007 02:34:27 pm"
To: john stultz <johnstul@us.ibm.com>
Date: Wed, 21 Mar 2007 16:00:38 -0600 (CST)
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070321220038.5D962DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> Hmmm. Are you able to capture a full dmesg?

For the "it hangs" case, short of either trying to boot with the
console I/O redirected to a serial port or hooking up a printer to
the console and scanning in the resulting output, I don't think so.
There's too much output prior to the hang point to make manual
transcription feasible.

> Also, does booting w/ "clocksource=jiffies" change the behavior?

I'll build a post-"bad"-commit kernel later this evening and let you
know.  Unfortunately, real life has to intrude for a few hours :-).
If specifying the clocksource allows for a normal bootup, would you
like to see the corresponding dmesg output?

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
