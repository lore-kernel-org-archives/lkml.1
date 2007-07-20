Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbXGTMag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbXGTMag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXGTMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:30:28 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60077 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXGTMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:30:27 -0400
Message-ID: <46A0AA98.5060901@gmail.com>
Date: Fri, 20 Jul 2007 14:29:12 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partition table recovery
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com>
In-Reply-To: <200707201522.17270.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2007 02:22 PM, Al Boldi wrote:

> Oh, gpart is great, but if we had a backup copy of the partition table on
> every partition location on disk, then this backup copy could easily be
> reused to reconstruct the original partition table without further 
> searching.

As long as you don't reboot you have a "backup copy" in kernel. Admittedly 
not in a very nice format, but /sys/block/<disk>/<part>/start and size have 
saved my butt a few times...

Rene.
