Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYBXVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYBXVyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBXVyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:54:09 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:18899 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753661AbYBXVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:54:07 -0500
X-Trace: 687569676/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEd2wUdRAVlC/2dsb2JhbACBVagi
Subject: Re: [PATCH] maple: fix device detection
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Greg KH <greg@kroah.com>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1203863423.6474.27.camel@localhost.localdomain>
References: <1203863423.6474.27.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 21:50:34 +0000
Message-Id: <1203889834.6474.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 14:30 +0000, Adrian McMenamin wrote:
> The maple bus driver that went into the kernel mainline in September 2007 contained some bugs which were revealed by the update of the kobj code for the current release series. Unfortunately those bugs also helped ensure maple devices were properly detected. This patch (against the current git) now ensures that devices are properly detected again.
> 

Further testing has shown this has introduced another bug, this time
limiting the effectiveness of subdevice detection. Please ignore this
while I work on a fix.

