Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZFBBB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZFBBB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZFBBBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:01:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:48610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZFBBBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:01:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,287,1241420400"; 
   d="scan'208";a="695584678"
Date: Tue, 2 Jun 2009 09:01:50 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Build failure caused by 'cpuidle: makes AMD C1E
	work in acpi_idle'
Message-ID: <20090602010150.GA21166@sli10-desk.sh.intel.com>
References: <200906011858.10575.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200906011858.10575.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 12:58:08AM +0800, Frans Pop wrote:
> $ git describe master
> v2.6.30-rc7-227-gd9244b5
> 
> [...]
> /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c: In 
> function ‘acpi_processor_power_verify’:
> /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c:617: 
> error: implicit declaration of function ‘acpi_timer_check_state’
> /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c: In 
> function ‘acpi_idle_enter_c1’:
> /home/fjp/projects/kernel/linux-2.6/drivers/acpi/processor_idle.c:839: 
> error: implicit declaration of function ‘acpi_state_timer_broadcast’
> make[7]: *** [drivers/acpi/processor_idle.o] Error 1
> 
> Reverting the following two commits fixed the error:
> 87ad57ba cpuidle: makes AMD C1E work in acpi_idle
> 7d60e8ab cpuidle: fix AMD C1E suspend hang
> 
> (Second one probably was not needed, but done as it looked related.)
Can't reproduce it here with your config, can you double check please?

Thanks,
Shaohua
