Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbXBNBnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbXBNBnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbXBNBnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:43:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49749 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbXBNBnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:43:10 -0500
Message-ID: <45D2692D.1070505@vmware.com>
Date: Tue, 13 Feb 2007 17:43:09 -0800
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
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com> <45D262DC.2020008@goop.org> <45D2635D.9070205@vmware.com> <45D267E8.7090506@goop.org>
In-Reply-To: <45D267E8.7090506@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Ok.  As long as we plan on patching CR2 and CR0 / clts accessors for
>> FPU save during context switch and page fault paths in the future.
>>     
>
> That's up to each backend, right?  Or do these need to be patched for a
> correctness reason?
>   

No, it needs to be part of the general patch list first, which is still 
hand listed rather than just any op being patchable.  Then it can be up 
to the backend.

Zach
