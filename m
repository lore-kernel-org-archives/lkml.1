Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXCUWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXCUWYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965384AbXCUWYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:24:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58773 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378AbXCUWYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:24:19 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: john stultz <johnstul@us.ibm.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
In-Reply-To: <20070321220038.5D962DBA1@gherkin.frus.com>
References: <20070321220038.5D962DBA1@gherkin.frus.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 15:24:12 -0700
Message-Id: <1174515853.5477.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 16:00 -0600, Bob Tracy wrote:
> john stultz wrote:
> > Hmmm. Are you able to capture a full dmesg?
> 
> For the "it hangs" case, short of either trying to boot with the
> console I/O redirected to a serial port or hooking up a printer to
> the console and scanning in the resulting output, I don't think so.
> There's too much output prior to the hang point to make manual
> transcription feasible.

Hmm. You could give netconsole a try(see
Documentation/networking/netconsole.txt), although if the hang is before
that inits you might be out of luck.

> > Also, does booting w/ "clocksource=jiffies" change the behavior?
> 
> I'll build a post-"bad"-commit kernel later this evening and let you
> know.  Unfortunately, real life has to intrude for a few hours :-).

No problem. When you can get to it. :)

Also trying booting w/ "notsc" would be a useful data point.

> If specifying the clocksource allows for a normal bootup, would you
> like to see the corresponding dmesg output?

No, although a pre-bad-commit dmesg would help.

thanks
-john

