Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbXBMWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbXBMWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXBMWy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:54:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37107 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbXBMWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:54:28 -0500
Message-ID: <45D241A2.6000401@vmware.com>
Date: Tue, 13 Feb 2007 14:54:26 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 13/21] Xen-paravirt: Add nosegneg capability to the vsyscall
 page notes
References: <20070213221729.772002682@goop.org> <20070213221830.466651996@goop.org> <45D23F97.5040907@vmware.com> <45D24066.4070109@goop.org>
In-Reply-To: <45D24066.4070109@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> I don't like this because now a kernel compiled with both CONFIG_XEN
>> and CONFIG_VMI has "nosegneg" turned on.  We don't actually require
>> this for performance or correctness, so it would be nice to be able to
>> dynamically turn it off instead of having it forced. 
>>     
>
> Any suggestions about how to do this?  It seems hard to have a note
> dynamically appear and disappear in the vsyscall.so.
>
> I wasn't terribly concerned about this, since there is effectively zero
> performance difference between the two library implementations.
>   

I'm not super concerned either, but I still don't like it.  There 
already is dynamic replacement for vsyscall.so, so you could have just 
dropped in an an-note-ated version.

Zach
