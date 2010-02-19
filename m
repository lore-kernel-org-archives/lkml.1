Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0BSHXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:23:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39815 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0BSHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:23:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B7E3CC5.9040901@np.css.fujitsu.com>
Date: Fri, 19 Feb 2010 16:24:53 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 4/8] ACPI: Use GPE reference counting to support shared
 GPEs
References: <201002172335.47703.rjw@sisk.pl> <201002172341.07353.rjw@sisk.pl> <4B7CE6A3.7020103@np.css.fujitsu.com> <201002182101.44171.rjw@sisk.pl>
In-Reply-To: <201002182101.44171.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael J. Wysocki

Rafael J. Wysocki wrote:
> On Thursday 18 February 2010, Jin Dongming wrote:
>> Hi, Rafael J. Wysocki
>>> -	/* Update enable mask, but don't enable the HW GPE as of yet */
>>> -
>>> -	status = acpi_ev_enable_gpe(gpe_event_info, FALSE);
> 
> You could preserve some more context.
> 
>> I think the above line code should be remained. If it is deleted, the exception 
>> event will be raised on some machine.
> 
> Why would it?  The GPE is still disabled at the hardware level at this point.
> 
> Rafael
> 
> 
I am very sorry for my wrong comment. The GPE is still disabled as you wrote.

The error message what I got was not caused by GPE event, it was caused by the "status"
variable which had not been deleted on x86-next tree. And it is also deleted at this
file. So I don't there is problem here.

Best regards,
Jin Dongming

