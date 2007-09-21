Return-Path: <linux-kernel-owner+w=401wt.eu-S1751129AbXIUGQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbXIUGQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXIUGQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:16:45 -0400
Received: from 1wt.eu ([62.212.114.60]:2602 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbXIUGQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:16:45 -0400
Date: Fri, 21 Sep 2007 08:16:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.y, 2.6.20.y] ieee1394: ohci1394: fix initialization if built non-modular
Message-ID: <20070921061624.GA20522@1wt.eu>
References: <tkrat.e46434c80b622f2b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.e46434c80b622f2b@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 08:11:08AM +0200, Stefan Richter wrote:
> Initialization of ohci1394 was broken according to one reporter if the
> driver was statically linked, i.e. not built as loadable module.  Dmesg:
> 
>   PCI: Device 0000:02:07.0 not available because of resource collisions
>   ohci1394: Failed to enable OHCI hardware.
> 
> This was reported for a Toshiba Satellite 5100-503.  The cause is commit
> 8df4083c5291b3647e0381d3c69ab2196f5dd3b7 in Linux 2.6.19-rc1 which only
> served purposes of early remote debugging via FireWire.  This
> functionality is better provided by the currently out-of-tree driver
> ohci1394_earlyinit.  Reversal of the commit was OK'd by Andi Kleen.
> 
> Same as pre-2.6.23 commit be7963b7e7f08a149e247c0bf29a4abd174e0929.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---

thanks Stefan. I still have a few fixes pending for 2.6.20, I'll release
another one soon including your patch.

regards,
willy

