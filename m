Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXBNBSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXBNBSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXBNBSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:18:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34482 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbXBNBSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:18:22 -0500
Message-ID: <45D2635D.9070205@vmware.com>
Date: Tue, 13 Feb 2007 17:18:21 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure,
 do individual functions
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com> <45D262DC.2020008@goop.org>
In-Reply-To: <45D262DC.2020008@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> This turned out really hideous looking to me.  Can't we split the
>> struct into GPL'd and non-GPL'd functions instead?  We still have the
>> same granularity, and none of this function call to an indirect
>> function call nonsense. 
>>     
>
> It's not pretty, but I think having paravirt_ops and paravirt_ops_gpl
> would be worse.  I'd be sympathetic to the idea of splitting
> paravirt_ops up by function groupings, but splitting it by license seems
> like a maintenance headache with no real upside.  Besides, patching will
> solve everything (tm).
>   

Ok.  As long as we plan on patching CR2 and CR0 / clts accessors for FPU 
save during context switch and page fault paths in the future.
