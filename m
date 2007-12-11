Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXLKSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXLKSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbXLKSiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:38:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:12184 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbXLKSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:38:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,153,1196668800"; 
   d="scan'208";a="234322722"
Message-ID: <475ED912.609@linux.intel.com>
Date: Tue, 11 Dec 2007 13:38:10 -0500
From: Anas Nashif <nashif@linux.intel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <475EC9C1.9080708@linux.intel.com> <p7363z5nlo8.fsf@bingen.suse.de>
In-Reply-To: <p7363z5nlo8.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are different ways you can connect to the Firmware and it all depends on
the ME subsystem you want to communicate with.
For Intel AMT, you would use LMS (Local Manageability Service) which acts as a
proxy for SOAP messages coming for management applications. LMS is available via
http://openamt.org/wiki/LocalManageabilityService.

The demo we had for storing kernel oops messages in the firmware used the AMT
1.0 interface (legacy) which allowed direct access to 3PDS using the MEI driver
interfaces. In AMT 3.0 (current platforms) this has been disabled and only SOAP
is possible which is why in the demo we changed the ME firmware to use AMT 1.0.

To have a feel for all of this, with many examples, samples and documentation
you can download the AMT 3.0 SDK (google: intel amt sdk).

Anas



Andi Kleen wrote:
> Anas Nashif <nashif@linux.intel.com> writes:
>> The Intel Management Engine Interface (aka HECI: Host Embedded 
>> Controller Interface ) enables communication between the host OS and 
>> the Management Engine firmware. MEI is bi-directional, and either the 
>> host or Intel AMT firmware can initiate transactions.
> 
> Can you please expand a bit on who on the host OS would actually communicate
> with the management engine? It looks like this driver just exports
> an interface to user space. What user space would use it and for
> what?
> 
> I would be definitely interested in a way to save oops information
> away using this.  I remember you had a demo for this, is support
> for that coming soon?
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
