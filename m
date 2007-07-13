Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbXGMRiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbXGMRiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbXGMRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:38:08 -0400
Received: from opinicus.com ([24.73.193.242]:44173 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757454AbXGMRiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:38:07 -0400
Message-ID: <4697B85B.4040902@opinicus.com>
Date: Fri, 13 Jul 2007 13:37:31 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: e100 PCI bridge problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In an earlier post to the list I described a hard lockup condition
that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
and occurs on 2 out of 3 computers.

Further testing has revealed that the lockup can be prevented on all
computers by making sure the card is installed on the primary PCI bus.
If the card is installed in a slot on the secondary PCI bus (behind a
PCI to PCI bridge) the lockup occurs.

Are there any PCI tuning registers that I can tweak to get around
this problem?  Any changes I could make to the e100 driver to fix this?

Any help appreciated.

Regards,
Wm

