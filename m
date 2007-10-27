Return-Path: <linux-kernel-owner+w=401wt.eu-S1765977AbXJ0ATu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765977AbXJ0ATu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXJ0ATm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:19:42 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:11963 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXJ0ATl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:19:41 -0400
Date: Sat, 27 Oct 2007 02:19:38 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Mark Gross <mgross@linux.intel.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] iommu-PMEN_REG boot up support
Message-ID: <20071027001938.GB10215@rhun.ibm.com>
References: <20071026181849.GA25256@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026181849.GA25256@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:18:49AM -0700, Mark Gross wrote:

> The following patch clears the portect memory region enable bit at
> boot time by default.  It also provides a kernel parrameter for
> disabling this behavior and leave the PMEN_REG untouched if so
> wanted.
> 
> If the boot loader or platform has protected memory regions enabled
> at boot time it could prevent DMA's from happening as drivers are
> loaded and used.

What's the value of adding a command line option for this? Under what
circumstances would we want to not clear this bit?

> +		} else if (!strncmp(str, "no_epm_clear", 12)) {
> +			printk(KERN_INFO
> +				"Intel-IOMMU: subress clearing of Enable "
> +				"Protected Memory bit\n");
> +			clear_pmen_epm = 0;

`suppress', I assume. Rest looks fine, if the configuration option is
really needed.

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
