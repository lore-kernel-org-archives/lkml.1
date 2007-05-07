Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXEGNV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXEGNV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933815AbXEGNV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:21:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45258 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbXEGNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:21:25 -0400
Message-ID: <463F27CE.2040008@garzik.org>
Date: Mon, 07 May 2007 09:21:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
References: <m3abwhcy74.fsf@maximus.localdomain> <m3y7k1biov.fsf@maximus.localdomain> <Pine.LNX.4.64.0705070343330.2733@scrub.home> <m3tzupc6wz.fsf@maximus.localdomain> <Pine.LNX.4.64.0705071318150.1479@scrub.home> <m3r6psc0ee.fsf@maximus.localdomain> <Pine.LNX.4.64.0705071509290.1479@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0705071509290.1479@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> Hi,
> 
> On Mon, 7 May 2007, Krzysztof Halasa wrote:
> 
>> Actually I can't see any bad idea here.
>> The original dependency was certainly, uhm, not the best one.
> 
> select seriously screws with the dependencies, it's especially problematic 
> if the selected symbol has other dependencies as HDLC in this case, it 
> makes it only more complicated to get the dependencies correct again.
> Please use it only if it solves a real problem.

What he's doing is the standard way to deal with library-style code. 
Nothing wrong with the patch, it's continuing established methods.

	Jeff



