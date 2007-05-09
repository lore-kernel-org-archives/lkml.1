Return-Path: <linux-kernel-owner+w=401wt.eu-S969141AbXEIFWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969141AbXEIFWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966105AbXEIFWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:22:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49081 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909AbXEIFWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:22:18 -0400
X-Sasl-enc: ZL9bVs61Vl5CIlf+lUIML6Vv0EAj7zIrvojcS1RxYObi 1178688136
Message-ID: <46415A26.6080209@whitby.id.au>
Date: Wed, 09 May 2007 14:50:38 +0930
From: Rod Whitby <rod@whitby.id.au>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Michael-Luke Jones <mlj28@cam.ac.uk>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>
CC: netdev@vger.kernel.org, Tomasz Chmielewski <mangoo@wpkg.org>,
       linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Why run ixp4xx LE? (Was: [PATCH] Intel IXP4xx network drivers v.2
 - Ethernet and HSS)
References: <464034CF.20700@wpkg.org>	<f19298770705080148u70638ac2ue87241382681088@mail.gmail.com> <FCBED7DF-2A16-419A-865D-663C34437579@cam.ac.uk>
In-Reply-To: <FCBED7DF-2A16-419A-865D-663C34437579@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael-Luke Jones wrote:
> On 8 May 2007, at 09:48, Alexey Zaytsev wrote:
> 
>> I was always curious, why do people want to run ixp4xx in LE mode? What
>> are the benefits that overweight the obvious performance degradation?
> 
> Debian.
> http://www.debian.org/ports/arm/

And also out-of-kernel drivers for things like webcams, which have been
naively written for x86 little endian and have no concept of endian
neutrality.  In some cases it's just easier to run LE instead of
fighting with the driver code.

BTW, for the consumer-level IXP42x devices (like the NSLU2) the
performance difference is *completely* overwhelmed by slowness in the
rest of the system.

-- Rod
