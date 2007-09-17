Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbXIQOb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbXIQOb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXIQObq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:31:46 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20416 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbXIQObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:31:45 -0400
Date: Mon, 17 Sep 2007 08:30:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <20070917133106.B21399@jurassic.park.msu.ru>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <gregkh@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-id: <46EE8F8A.9020104@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
 <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca>
 <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca>
 <20070916151355.A18508@jurassic.park.msu.ru>
 <20070916195258.GC28350@parisc-linux.org>
 <20070917133106.B21399@jurassic.park.msu.ru>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Sun, Sep 16, 2007 at 01:52:59PM -0600, Matthew Wilcox wrote:
>> I don't think it would be that complicated.  We could just delay probing
>> for mmconfig until after the pci bus probes are done.  No changes to
>> other architectures needed.
> 
> Indeed. Seems like it's a way to go.

With another patch pending for 2.6.24, to validate the MMCONFIG aperture 
against the ACPI motherboard resources instead of the E820 table, we 
have to delay switching to MMCONFIG until the ACPI interpreter is 
available (unless no other configuration mechanism is available). It 
might thus be feasible to delay it further.

Nevertheless, I think this is a rather ugly workaround for the 
underlying problem.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

