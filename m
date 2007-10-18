Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbXJRVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbXJRVLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbXJRVLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:11:13 -0400
Received: from rtr.ca ([76.10.145.34]:4820 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758817AbXJRVLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:11:12 -0400
Message-ID: <4717CBEC.4060403@rtr.ca>
Date: Thu, 18 Oct 2007 17:11:08 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
References: <4716CB9D.6080503@rtr.ca>	<4716CE79.7040201@rtr.ca>	<20071018091347.4b94faf8.kristen.c.accardi@intel.com>	<4717928D.6070703@rtr.ca>	<20071018100614.435fe88c.kristen.c.accardi@intel.com>	<20071018174925.GB4927@thunk.org> <20071018105601.27d96f7e.kristen.c.accardi@intel.com>
In-Reply-To: <20071018105601.27d96f7e.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Thu, 18 Oct 2007 13:49:25 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
>> On Thu, Oct 18, 2007 at 10:06:14AM -0700, Kristen Carlson Accardi wrote:
>>> No, it actually does violate the spec.  Feel free to read it yourself.
>>> We are not supposed to do Native PCIe without first successfully executing
>>> OSC.  Period.  If you do, you are violating the spec.
>> To be fair, we have violated the spec before in order to get crappy
>> hardware or to work around crappy ACPI implementations.
>> acpi_sleep=s3_bios for example violates the spec, but yet it is the
>> only way to get certain laptops to suspend/resume correctly.  
>>
>> The question to ask is whether violating the spec will lead to (a) a
>> potential system hang/crash, (b) data corruption, (c) physical harm to
>> the device/laptop.
>
> And the answer is most definitely yes to at least a) and c) on specific
> hardware I know about.

I'm hearing a lot of FUD here, with no details.
Please, tell us more..

Thanks.
