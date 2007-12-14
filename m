Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXLNXS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXLNXS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXLNXSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:18:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42166 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbXLNXSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:18:10 -0500
Message-ID: <47630F23.5060403@garzik.org>
Date: Fri, 14 Dec 2007 18:17:55 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: akpm@linux-foundation.org, netdev@vger.kernel.org, randy.dunlap@oracle.com,
       auke-jan.h.kok@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/10] e1000e: make E1000E default to the same kconfig
 setting as E1000
References: <200712140002.lBE02pUb025505@imap1.linux-foundation.org> <4762E9FE.1070707@garzik.org> <20071214223947.GA5403@stusta.de>
In-Reply-To: <20071214223947.GA5403@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Dec 14, 2007 at 03:39:26PM -0500, Jeff Garzik wrote:
>> akpm@linux-foundation.org wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> ...
>> So I think the breakage that occurs is mitigated by two factors:
>> 1) kernel hackers that do their own configs are expected to be able to 
>> figure this stuff.
>> 2) kernel builders (read: distros, mainly) are expected to have put thought 
>> into the Kconfig selection and driver migration strategies.
>> ...
>> I would prefer simply to communicate to kernel experts and builders about a 
>> Kconfig issue that could potentially their booting/networking...  because 
>> this patch is only needed if the kernel experts do not already know about a 
>> necessary config update.
> 
> You miss the vast majority of kconfig users:
> 
> 3) system administrators etc. who for different reasons compile their 
> own kernels but neither are nor want to be kernel developers
> 
> There's a reason why e.g. LPI requires you to be able to compile your 
> own kernel even for getting a "Junior Level Linux Professional" 
> certificate.

Great!


> Or that one of the authors of "Linux Device drivers" has written a book 
> covering only how to build and run your own kernel.

Nonetheless, it will always be true that configuring your own kernel 
requires knowledge of the options you are setting.

	Jeff



