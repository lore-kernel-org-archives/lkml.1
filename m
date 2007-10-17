Return-Path: <linux-kernel-owner+w=401wt.eu-S936426AbXJQDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936426AbXJQDbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQDbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:31:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54134 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbXJQDbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:31:23 -0400
Date: Tue, 16 Oct 2007 21:31:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <lkml@rtr.ca>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 2/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version 2)
Message-ID: <20071017033121.GB16728@parisc-linux.org>
References: <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca> <47156B62.3070807@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47156B62.3070807@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 09:54:42PM -0400, Mark Lord wrote:
>  		if (rc)
>  			goto err_out_free_ctrl_slot;
> -	}
> +	} else if (pciehp_force)
> +		pciehp_enable_slot(t_slot);
>  

I find the construct if () { ... } else ...; to be a bit jarring.  How
about adding the extra braces?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
