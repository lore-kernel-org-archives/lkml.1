Return-Path: <linux-kernel-owner+w=401wt.eu-S965648AbXCPQ51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbXCPQ51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXCPQ51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:57:27 -0400
Received: from gw.goop.org ([64.81.55.164]:36802 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965648AbXCPQ50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:57:26 -0400
Message-ID: <45FACC76.1020902@goop.org>
Date: Fri, 16 Mar 2007 09:57:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 24/26] Xen-paravirt_ops: Add the Xenbus sysfs and virtual
 device hotplug driver.
References: <20070301232443.195603797@goop.org> <20070301232529.271605211@goop.org> <20070316084704.GB23174@elte.hu>
In-Reply-To: <20070316084704.GB23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This communicates with the machine control software via a registry 
>> residing in a controlling virtual machine. This allows dynamic 
>> creation, destruction and modification of virtual device 
>> configurations (network devices, block devices and CPUS, to name some 
>> examples).
>>     
>
> should be reviewed by the driver-core folks too i guess?
>
>   
>> +//#include <asm/maddr.h>
>>     
>
>   
>> +//#include <xen/xen_proc.h>
>> +//#include <xen/evtchn.h>
>>     
>
>   
>> +//#include <xen/hvm.h>
>>     
>
>   
>> +//		.shutdown = xenbus_dev_shutdown,
>>     
>
> hm?
>   

Yeah, gunk.  I'll clean that out.

    J
