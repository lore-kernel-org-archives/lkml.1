Return-Path: <linux-kernel-owner+w=401wt.eu-S1767469AbXDFBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767469AbXDFBe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767485AbXDFBe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:34:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36737 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767469AbXDFBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:34:26 -0400
Message-ID: <4615A32D.2080209@vmware.com>
Date: Thu, 05 Apr 2007 18:32:29 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com> <46159555.4020706@goop.org> <4615982A.1070700@vmware.com> <461599C1.50002@goop.org> <46159A2A.8050804@vmware.com> <4615A2F8.7040602@goop.org>
In-Reply-To: <4615A2F8.7040602@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Throw it in the queue; I'll slide in after it.
>>     
>
> I've pushed it up.  I added a few missing cases to the patch
> (kmap_atomic_pte, kunmap_atomic).
>   

Do you mean kmap_atomic_pfn?  kunmap_atomic can stay lazy (at least for 
VMI), actually, but it doesn't help since it happens outside the spin lock.

