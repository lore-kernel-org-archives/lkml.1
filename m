Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXCBBSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXCBBSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161178AbXCBBSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:18:13 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45572 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161169AbXCBBSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:18:12 -0500
Message-ID: <45E77B53.1060309@vmware.com>
Date: Thu, 01 Mar 2007 17:18:11 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include
 return register
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org> <45E7738D.5090607@vmware.com> <45E774AB.5090103@goop.org> <45E77569.9010602@vmware.com> <45E776D0.9020609@goop.org>
In-Reply-To: <45E776D0.9020609@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>>> Things like what?  Do you mean the %[foo] asm parameter syntax?  I think
>>> those versions are no longer supported - Arjan posted a patch a few days
>>> ago to convert a pile of asms to this form.  Or do you mean something
>>> else?
>>>   
>>>       
>> I meant having an output in the clobber list,
>>     
>
> There's no output in the clobber list, just "memory" and "cc".  The
> paravirt_clobber() is the stuff which gets put in the .parainstructions
> section which tells the patcher what registers are expected to be
> modified at that callsite (including both temp and output registers).
>   

Ah, ok.  I didn't think gcc had grown the appropriate antlers yet to 
allow outputs in the clobber list.  But the paravirt-clobbers, yes that 
makes sense.

Zach
