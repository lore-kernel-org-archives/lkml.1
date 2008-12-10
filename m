Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYLJNXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYLJNXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLJNXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:23:36 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:25474 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbYLJNXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:23:35 -0500
From: Frans Pop <elendil@planet.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
Date: Wed, 10 Dec 2008 14:23:30 +0100
User-Agent: KMail/1.9.9
Cc: Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200812061316.38460.elendil@planet.nl> <493B42D1.7090600@shaw.ca> <493B953F.3070504@s5r6.in-berlin.de>
In-Reply-To: <493B953F.3070504@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101423.31838.elendil@planet.nl>
X-OriginalArrivalTime: 10 Dec 2008 13:23:32.0770 (UTC) FILETIME=[7F9DA020:01C95ACA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed reply.

On Sunday 07 December 2008, you wrote:
> Robert Hancock wrote:
> > Presumably it should.. but the fact remains that if free_irq helps
> > anything, then the device must be generating interrupts for some
> > reason,
>
> Or another device:
> http://www.gossamer-threads.com/lists/linux/kernel/896053

Martin has the same laptop as I have, but his symptoms are still 
different: he gets the error on boot, while I only get it on resume.

> Questions for Frans, quoting tglx:
> Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config?  If
> yes, can you please disable it and check whether the problem persists?

I had it enabled (due to NETCONSOLE), but disabling it makes no 
difference. I still get the "irq 19: nobody cared".
