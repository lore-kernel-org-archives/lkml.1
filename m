Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZA2J2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZA2J2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZA2J2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:28:03 -0500
Received: from gw.goop.org ([64.81.55.164]:51140 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZA2J2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:28:01 -0500
Message-ID: <498176A0.3020202@goop.org>
Date: Thu, 29 Jan 2009 01:28:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 3 of 7] x86: fix paravirt clobber in entry_64.S
References: <patchbomb.1233182100@abulafia.goop.org> <138b9e1650b385d5ac9d.1233182103@abulafia.goop.org> <200901291909.18929.rusty@rustcorp.com.au>
In-Reply-To: <200901291909.18929.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 29 January 2009 09:05:03 Jeremy Fitzhardinge wrote:
>   
>> The clobber is trying to say that anything except RDI is available for
>> clobbering, but actually clobbers everything.  This hasn't mattered
>> because the clobbers were basically ignored, but subsequent patches
>> will rely on them.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Hmm, did we never have the deliberate-clobbering debug code for 64 bit?
>   

No.  I think I killed it off before 64-bit was even started.  There was 
some confusion about whether the return regs were considered to be 
"clobbered" or not, but I don't remember the details.

    J
