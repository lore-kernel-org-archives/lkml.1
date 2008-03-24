Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYCXVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYCXVt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYCXVtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:49:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54543 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYCXVtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:49:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E8217C.9080400@s5r6.in-berlin.de>
Date: Mon, 24 Mar 2008 22:47:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de>
In-Reply-To: <47E807EE.2030902@m3y3r.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> Linus Torvalds schrieb:
>> Does this patch make any difference?
> Yes. With this patch applied the error messages doesn't appear anymore.
...
> [    2.232822] ohci1394: Failed to remap registers - card not accessible
...
> [    2.551959] firewire_ohci: Failed to remap registers

ioremap() fails now.
-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/
