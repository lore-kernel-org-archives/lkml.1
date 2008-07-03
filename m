Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYGCNtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYGCNtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYGCNsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:48:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:12197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699AbYGCNsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="302386700"
Message-ID: <486CD8C3.7030007@linux.intel.com>
Date: Thu, 03 Jul 2008 15:48:51 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, akpm@osdl.org
Subject: Re: next-0702: ACPI Error (nseval-0159): Insufficient arguments
References: <a4423d670807030607s28bc7205l3bf46b49cff4176d@mail.gmail.com>
In-Reply-To: <a4423d670807030607s28bc7205l3bf46b49cff4176d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> Hi
> 
> I have several these messages.
> It is Dual-Core Opteron 1214.
> 
> CONFIG_ACPI=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_PNPACPI=y
> 
> Let me know if you need more info.
> 
> [    0.888708] WARNING: at nseval:159 acpi_ut_error+0x32/0xa2()

Andrew, that's the bad side effect I talked about earlier. Now the
warning doesn't report the right place, but just the error function
and it's unclear who causes it due to the unreliable backtrace.

Alexander,

Is this something that you didn't see in older kernels? If yes when did 
it start?

Can you please file a full report in http://bugzilla.kernel.org?

Thanks,
-Andi
