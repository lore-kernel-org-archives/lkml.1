Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZEVDjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZEVDjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 23:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZEVDjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 23:39:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZEVDjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 23:39:39 -0400
Message-ID: <4A161E55.4040401@zytor.com>
Date: Thu, 21 May 2009 20:39:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xin, Xiaohui wrote:
> Remember we have done one experiment with "jump", the result shows seems the overhead is even more than the call.

I didn't, no.  That seems extremely weird to me.

(Unbalancing the call/ret stack is known to suck royally, of course.)

>>>
>>>     
>> Can't those calls be changed to jumps?
>>   
> 
> In this specific instance of this example, yes.  But if you start 
> enabling various spinlock debug options then there'll be code following 
> the call.  It would be hard for the runtime patching machinery to know 
> when it would be safe to do the substitution.
> 

When there is code after the call, it's rather obviously not safe.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

