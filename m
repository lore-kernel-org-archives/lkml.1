Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYBKUPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYBKUPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYBKUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:14:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:57001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYBKUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="338255034"
Date: Mon, 11 Feb 2008 12:06:50 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Calvin Walton <calvin.walton@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
Message-ID: <20080211200650.GA8287@linux-os.sc.intel.com>
References: <47AFDC4D.4070400@gmail.com> <1202708864.5206.0.camel@zem> <924EFEDD5F540B4284297C4DC59F3DEE8608D3@orsmsx423.amr.corp.intel.com> <47B0A3E0.4050908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B0A3E0.4050908@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 05:37:04PM -0200, Carlos R. Mafra wrote:
> Pallipadi, Venkatesh wrote:
> > 
> > Can you send me the output of acpidump and full dmesg to me. Looks like
> > it is a platform issue due to which we cannot use C1 mwait idle during
> > suspend resume, something similar to issue we had with using C2/C3 state
> > during idle.
> 
> Full dmesg and acpidump outputs are attached.

Above acpidump doesnt have all info, as it is loading some SSDT at run time.
Can you get the output of

# acpidump --addr 0x7F6D8709 --length 0x000004B7
# acpidump --addr 0x7F6D8BC0 --length 0x00000092

Thanks,
Venki

