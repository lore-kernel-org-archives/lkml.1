Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXCVDpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXCVDpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 23:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXCVDpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 23:45:25 -0400
Received: from gherkin.frus.com ([192.158.254.49]:57520 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965634AbXCVDpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 23:45:24 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <1174515853.5477.18.camel@localhost.localdomain>
 "from john stultz at Mar 21, 2007 03:24:12 pm"
To: john stultz <johnstul@us.ibm.com>
Date: Wed, 21 Mar 2007 21:45:23 -0600 (CST)
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070322034523.90050DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> > > Also, does booting w/ "clocksource=jiffies" change the behavior?

Works fine with 2.6.21-rc4.  I'm running on that kernel as I type this.

> Also trying booting w/ "notsc" would be a useful data point.

Boot hangs at the point indicated in my original message.  I *did*
notice the blurb in the console messages about the pit clocksource
being selected/used.  There was also a complaint about it being
unstable, with a negative delta.  I think these messages are consistent
with the pre-bad-commit case other than where they appear in the boot
messages.

> (...) a pre-bad-commit dmesg would help.

Sent under separate cover to John.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
