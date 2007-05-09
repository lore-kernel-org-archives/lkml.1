Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbXEIOr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbXEIOr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXEIOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:47:14 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:39586 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbXEIOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:47:13 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <4641D920.2020508@roinet.com>
References: <464034CF.20700@wpkg.org> <f1s2eu$26p$1@sea.gmane.org> <20070509092132.GB6976@xi.wantstofly.org> <200705091135.06405.marcus@better.se> <20070509110415.GA7513@xi.wantstofly.org> <4641D920.2020508@roinet.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <47B3C8DF-D72E-45D4-8381-D77FDCD89DB8@cam.ac.uk>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Marcus Better <marcus@better.se>
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Date: Wed, 9 May 2007 15:45:53 +0100
To: David Acker <dacker@roinet.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2007, at 15:22, David Acker wrote:
> Big endian is the natural setup for the NPEs on this hardware  
> according to the intel documentation.  Please don't stop this  
> driver from moving forward so that a few folks can run their  
> hardware in slow mode.

No-one is saying that this driver should not be mainlined before it  
has LE support. All that I said was:

> Personally I'd like LE ethernet tested and working before we push.

The alternative would be to explicitly state in Kconfig that LE arm  
is broken with this driver, so that this could be fixed later.

Please can we not blow this out of proportion, it really isn't that  
big a deal. The irony is that fixing Krzysztof's driver to work on LE  
will probably be quite easy, given that we already have a working LE  
driver from Christian.

Michael-Luke

PS: It really isn't just 'a few folks' - at NSLU2-Linux we have 5000  
people who have downloaded Debian/LE for NSLU2 and are currently  
using Christian's driver with great success. We would just like to  
replicate that support with this new driver.

