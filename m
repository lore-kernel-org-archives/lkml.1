Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXCFHma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXCFHma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXCFHma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:42:30 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38284 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbXCFHm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:42:29 -0500
Message-ID: <45ED1B64.9040104@vmware.com>
Date: Mon, 05 Mar 2007 23:42:28 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <20070306073511.GA3938@elte.hu>
In-Reply-To: <20070306073511.GA3938@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> I had just sent this out for internal review...
>>>       
>> I think Jan's approach is better if it works (since there's no 
>> compromise), but this is better if you want to get something working 
>> in the near term.
>>     
>
> yeah. (plus my patches of course that remove the current papering-over 
> hackery and restores COMPAT_VDSO.)
>   

Yes, I don't have a problem with your patch, I just wish I had been cc'd 
on it.  Fixing this is rather tricky, but I believe no strange build 
magic is required, it can be done in kernel init code.  Still building 
my SUSE 9.0 guest to test.  SUSE 9.0 is one of those that requires 
COMPAT_VDSO, yes?

Thanks,

Zach
