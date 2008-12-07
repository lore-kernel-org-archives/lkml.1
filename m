Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYLGJUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYLGJUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 04:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYLGJUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 04:20:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39419 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYLGJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 04:20:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <493B953F.3070504@s5r6.in-berlin.de>
Date: Sun, 07 Dec 2008 10:19:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <200812061536.47894.elendil@planet.nl> <493AE8B3.7090000@shaw.ca> <tkrat.fd592eed61e41b8f@s5r6.in-berlin.de> <493B42D1.7090600@shaw.ca>
In-Reply-To: <493B42D1.7090600@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Stefan Richter wrote:
>>     reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
>>
>> in ohci1394's .suspend() switches interrupts off.
> 
> Presumably it should.. but the fact remains that if free_irq helps
> anything, then the device must be generating interrupts for some reason,

Or another device:
http://www.gossamer-threads.com/lists/linux/kernel/896053

Questions for Frans, quoting tglx:
Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config?  If yes,
can you please disable it and check whether the problem persists?
-- 
Stefan Richter
-=====-==--- ==-- --===
http://arcgraph.de/sr/
