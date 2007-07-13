Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbXGMCi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbXGMCi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGMCiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:38:20 -0400
Received: from rtr.ca ([64.26.128.89]:3583 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbXGMCiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:38:19 -0400
Message-ID: <4696E598.4010609@rtr.ca>
Date: Thu, 12 Jul 2007 22:38:16 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com>	<200707121446.14170.rjw@sisk.pl> <469631FA.2070405@rtr.ca>	<200707121735.40077.rjw@sisk.pl> <469650DE.4000901@rtr.ca>	<46965837.8030907@rtr.ca> <87y7hl2xro.fsf@jbms.ath.cx>
In-Reply-To: <87y7hl2xro.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
>
> A typical usage pattern of hibernate on a laptop is to shut the lid,
> causing the system to start to hibernate, and to place the machine in

All laptops we have here, and those of all people I have seen
with laptops, do suspend-to-RAM on lid-close, not hibernate.

And even then, I generally wait to verify that the machine actually
did shut down, simply because the one time I didn't wait, Linux failed
to shutdown.  Which was discovered hours later at the end of the journey,
when a very hot notebook with a dead battery was unpacked.  Ugh.

Cheers
