Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZEVVdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZEVVdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZEVVcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:32:54 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:48907 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbZEVVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:32:54 -0400
Message-ID: <4A1719DE.4060009@unsolicited.net>
Date: Fri, 22 May 2009 22:32:14 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked down
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
finally had time to do some digging, and the regression is caused by:

    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups

..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
makes the card work happily again.

I don't know enough about USB protocols to speculate on whether there
may be a better fix, but hopefully someone cleverer than me can get to
the bottom of the problem?

Cheers
David



