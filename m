Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXI1Tn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXI1Tn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXI1TnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:43:12 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45193 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbXI1TnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:43:10 -0400
X-Originating-Ip: 216.16.235.2
Date: Fri, 28 Sep 2007 15:42:51 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: Temporarily disabling CONFIG_USB_SUSPEND
Message-ID: <20070928194251.GA7666@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: <cdfrey@netdirect.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a global means to disable the CONFIG_USB_SUSPEND feature, perhaps
through /proc or /sysfs?

I know this can be done, in a semi-reliable manner, on a per-device
basis by writing 0 or 2 to the /sys/.../device/power/state file, but
I'm looking for something that will have the same effect as disabling
CONFIG_USB_SUSPEND, but without recompiling the kernel.

Thanks,
- Chris

