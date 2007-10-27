Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbXJ0Npn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbXJ0Npn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXJ0Npg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:45:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41936 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468AbXJ0Npg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:45:36 -0400
Date: Sat, 27 Oct 2007 15:45:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6 patch] fix USB_OHCI_HCD_SSB dependencies
Message-ID: <20071027134556.GS30533@stusta.de>
References: <20071027010647.GN30533@stusta.de> <20071027085748.GB3742@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071027085748.GB3742@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 10:57:48AM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > -	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
> > +	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
> 
> oops, indeed ... my Kconfig fu needs strengthening. Does Kconfig warn 
> somewhere if it sees an erroneous CONFIG_ token?

No. IIRC Sam was working in getting warnings for such things, but 
currently kconfig simply can't know whether it's a bug or OK.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

