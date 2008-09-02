Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYIBAlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYIBAlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYIBAln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:41:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:35353 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYIBAlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:41:42 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Ge56xHuHBxxG6165nnUA:9 a=zWn6tAEHgG_Oe9GJdN-ExWaXkGkA:4 a=Xn-v4IG1PdIA:10 a=2K3t0So284kA:10
Message-ID: <48BC8BC8.4030308@shaw.ca>
Date: Mon, 01 Sep 2008 18:41:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcedeth: option to disable 100Hz timer
References: <fa.zbmDQFBw5U2qR0I4VSAlvj/j2ek@ifi.uio.no>
In-Reply-To: <fa.zbmDQFBw5U2qR0I4VSAlvj/j2ek@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikhail Kshevetskiy wrote:
> On some hardware no TX done interrupts are generated, thus special
> 100Hz timer interrupt is required to handle this situation properly.
> Other device do not require that timer interrupt feature.
> 
> Patch add a "disable_timerirq" option to disable interrupt timer 
> mentioned above. This may be extremely usefull for laptop users.
> 
> Mikhail Kshevetskiy
> 

Someone (ideally NVIDIA) should really find out what hardware actually 
requires this timer IRQ and only set the flag on those chipsets rather 
than blindingly setting it on everything. This patch would be useful to 
test whether a chipset does need it, however.
