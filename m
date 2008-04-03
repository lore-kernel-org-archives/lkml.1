Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYDCTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYDCTG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYDCTGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:06:22 -0400
Received: from rtr.ca ([76.10.145.34]:2531 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYDCTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:06:21 -0400
Message-ID: <47F52AAC.8090005@rtr.ca>
Date: Thu, 03 Apr 2008 15:06:20 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, david-b@pacbell.net,
       oliver@neukum.org, Alan Stern <stern@rowland.harvard.edu>
Subject: 2.6.25-rc7/8: Another resume regression
References: <200803220259.48534.rjw@sisk.pl> <alpine.LFD.1.00.0803311118120.14670@woody.linux-foundation.org> <47F13B8F.1000003@rtr.ca>
In-Reply-To: <47F13B8F.1000003@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Okay, USB now works fine on resume after fixing the iaa_watchdog issue.

But twice now, once before that fix, and again just a minute ago,
my machine has failed completely to resume after suspend-to-RAM.

Again, resume here is 100% reliable in 2.6.24 and earlier.

Symptoms: the usual:

  -- 2.6.25-rc8 (and -rc7 earlier), plus USB fix.
  -- not reproduceable on demand.
  -- black screen of death -- no backlight, no kernel messages.
  -- no hard drive activity.
  -- no alt-sysrq-anything.
  -- 5 second hold of the power button to poweroff and then recover.

Not much info to go on, but it's worth knowing there's an issue here somewhere.

Cheers
