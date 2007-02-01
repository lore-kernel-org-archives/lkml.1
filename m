Return-Path: <linux-kernel-owner+w=401wt.eu-S1751711AbXBAWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbXBAWSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXBAWSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:18:39 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:2457 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbXBAWSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:18:38 -0500
Message-ID: <45C2670F.5000003@jonmasters.org>
Date: Thu, 01 Feb 2007 17:17:51 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> Proposed patch to prohibit loading modules that use early C string 
> termination ("GPL\0 for nothing, folks!") to trick the kernel believing 
> it is loading a GPL driver.

Ok. I totally dig the *idea* here - I mean, this issue has been ongoing 
for a long time now. But I'd like to see a few comments as to whether we 
need a technological mechanism here to enforce the obvious. To me, it 
just seems totally obvious (any legal comment?) that early C string 
termination is undermining the intent of the MODULE_LICENSE tag.

The m-i-t patch seems ok and also cleans up the existing logic.

Jon.

P.S. Someone's fooling around with mailman on that box, I'll get the 
mailing list sorted out between now and the weekend or somesuch.
