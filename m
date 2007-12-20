Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbXLTMX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbXLTMX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbXLTMXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:23:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759535AbXLTMXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:23:19 -0500
Message-ID: <476A5EAF.6020008@redhat.com>
Date: Thu, 20 Dec 2007 07:23:11 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [Fwd: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce PCI_USING_MMCONF]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To all,

The next few forwarded messages comprise my responses to Greg's
questions about the patch I submitted to deal with pci devices
that do not respond correctly to x86 mmconf accesses.

Please accept my apologies for not having including the community
in my original responses.


-------- Original Message --------
Subject: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce PCI_USING_MMCONF
Date: Wed, 19 Dec 2007 18:58:45 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
To: Greg KH <gregkh@suse.de>
References: 
<20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219221751.20362.23451.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219230447.GA24219@suse.de>

Greg KH wrote:
> On Wed, Dec 19, 2007 at 05:17:51PM -0500, tcamuso@redhat.com wrote:
>>  
>> +extern struct pci_ops pci_legacy_ops; 	/* direct.c */
> 
> This isn't needed in this patch at all, and might make the compiler
> confused if you were to build with only this patch present :(
> 
> thanks,
> 
> greg k-h

Yes, of course. I missed that. Thank you.

Should I resubmit that one patch? Or would you prefer I resubmit
the whole patch set?


