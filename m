Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXJLXdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXJLXdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbXJLXdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:33:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31220 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbXJLXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:33:14 -0400
Message-ID: <471003F5.6050903@oracle.com>
Date: Fri, 12 Oct 2007 16:32:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] Allow kconfig to accept overrides
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071012155708.d8abd06d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710130127420.31913@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 12 2007 15:57, Randy Dunlap wrote:
>> On Fri, 12 Oct 2007 23:44:08 +0200 (CEST) Jan Engelhardt wrote:
>>
>>> warning("override: %s turns state choice", sym->name);
>> What does that warning message mean?  I can't decipher it.
> 
> It is when the value of a "choice" kconfig object is changed, for example
> this .config excerpt:
> 
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> # CONFIG_PREEMPT_BKL is not set
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_REEMPT_VOLUNTARY=y
> 
>> Other than that, it works for me.  Thanks.
> 
> /What/ works, the patch, or the tree without the patch? (Note I was
> testing that on 2.6.23.1, not the git head, so if someone silently
> merged things behind me, I might have missed it. Then again, that
> would have probably caused an offset, fuzz or reject, which was not
> the case.)

The patch and me modifying the .config file by hand to cause overrides.

-- 
~Randy
