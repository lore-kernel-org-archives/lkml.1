Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbYBSX7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbYBSX7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYBSX7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:59:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54380 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYBSX7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:59:39 -0500
Date: Tue, 19 Feb 2008 15:45:29 -0800
From: Greg KH <greg@kroah.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bootup crash, -git] Re: patch
	pci-pcie-aspm-support.patchadded to gregkh-2.6 tree
Message-ID: <20080219234529.GA12967@kroah.com>
References: <1201141317.26118.2.camel@sli10-desk.sh.intel.com> <12013009171835@kroah.org> <20080202105506.GA25160@elte.hu> <20080202185145.GA13005@kroah.com> <1203399945.12681.8.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203399945.12681.8.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 01:45:45PM +0800, Shaohua Li wrote:
> Sorry for the long delay, I just back from vocation. I fixed all the
> issues I found in the list (except one hang issue, which should be fixed
> in specific driver, I'll reply that thread soon), can you re-add the
> patch to your test tree.

Hm, I get the following build error with this patch:
	  CC      drivers/pci/pcie/aspm.o
	distcc[13135] ERROR: compile /home/gregkh/.ccache/aspm.tmp.mini.13131.i on localhost failed
	In file included from drivers/pci/pcie/aspm.c:21:
	include/linux/pci-acpi.h:66: error: expected ')' before 'handle'
	make[2]: *** [drivers/pci/pcie/aspm.o] Error 1
	make[1]: *** [drivers/pci/pcie] Error 2
	make: *** [_module_drivers/pci] Error 2


Also, can you rename your new header file to have "pci-" in front of it?

thanks,

greg k-h
