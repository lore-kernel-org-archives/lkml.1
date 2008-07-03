Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGCOi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGCOi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYGCOis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:38:48 -0400
Received: from mga10.intel.com ([192.55.52.92]:55833 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751242AbYGCOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:38:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="584760027"
Message-ID: <486CE46C.6040700@linux.intel.com>
Date: Thu, 03 Jul 2008 16:38:36 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: WARNING at acpi/.../utmisc.c:1043 [Was: 2.6.26-rc8-mm1]
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <486CE1A7.4030009@gmail.com>
In-Reply-To: <486CE1A7.4030009@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Andrew Morton napsal(a):
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/ 
>>
> 
> Running this in qemu shows up these 3 warnings while booting (It's 
> tainted due to previous MTRR warning which was there for ever):
> 
> PCI: Using configuration type 1 for base access
> ------------[ cut here ]------------
> WARNING: at /home/latest/xxx/drivers/acpi/utilities/utmisc.c:1043 

Not sure where that is coming from. My tree and my copy of linux-next
doesn't have a WARN_ON in this function.

Anyways, I assume you always saw this message right?

> ACPI Exception (evxface-0645): AE_BAD_PARAMETER, Installing notify 
> handler failed [20080609]
> ACPI: Interpreter enabled

And the only thing new is the backtrace right?

Similar with the other messages. If you ignore the backtraces
is there any difference?

-Andi
