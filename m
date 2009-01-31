Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZAaHQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZAaHQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZAaHQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:16:13 -0500
Received: from gw.goop.org ([64.81.55.164]:40895 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZAaHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:16:12 -0500
Message-ID: <4983FAB9.2010004@goop.org>
Date: Fri, 30 Jan 2009 23:16:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org> <49815764.6040809@kernel.org> <49817C26.2020503@goop.org> <4983DBC9.5080701@kernel.org>
In-Reply-To: <4983DBC9.5080701@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> H. Peter Anvin wrote:
>>     
>>> The failing configuration was x86-64 "make allyesconfig".
>>>
>>>     -hpa
>>>   
>>>       
>> Subject: x86/paravirt: fix missing callee-save call on pud_val
>>
>> Fix missed convertion to using callee-saved calls for pud_val, which
>> causes a compile error when CONFIG_PARAVIRT_DEBUG is enabled.
>>
>>     
>
> Series applied to tip:x86/paravirt; it should make its way into
> tip:master and linux-next over the next day or two, unless there are
> failures.

Thanks.  I have a couple of additional fixes.  Also, did you pick up 
those other two io.h patches I mailed you the other day?

    J
