Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZD0UAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZD0UAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbZD0UAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:00:13 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52146 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZD0UAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:00:12 -0400
Message-ID: <49F60EC9.2050501@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 13:00:09 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Ira Snyder <iws@ovro.caltech.edu>, Liu Dave-R63238 <DaveLiu@freescale.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu>	<49F60A3A.4060402@freescale.com>	<49F60BF8.8040404@ovro.caltech.edu> <46B638E2-885C-4281-81EA-CB685264E143@kernel.crashing.org>
In-Reply-To: <46B638E2-885C-4281-81EA-CB685264E143@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 13:00:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Can you give me an example of non-PCI memory that would be
>> non-prefetchable that you'd like us to try? We can see if our
>> host CPUs have an area like that ... we just need to know
>> what device to look for first :)
> 
> You can mark the pci inbound window on the 83xx as non-prefetchable 
> (assuming 83xx is host). On a x86 host I doubt there is any easy way to 
> get non-prefetchable memory.

Yep, we were going to do that, but chose to use the
1MB region already setup for the IMMRs since its already
marked as non-prefetchable. We were only doing reads, so
it wasn't going to hurt anything.

I doubt that marking one of the other BAR regions
as non-prefetchable will give a different result.
However, we're more than happy to double-check if
you'd like.

Cheers,
Dave

