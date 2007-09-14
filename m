Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbXINWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbXINWIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXINWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:08:29 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:40634 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXINWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:08:29 -0400
Message-ID: <46EB0657.40603@codemonkey.ws>
Date: Fri, 14 Sep 2007 17:08:23 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com> <46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws> <46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws> <46EB02BA.6030909@goop.org>
In-Reply-To: <46EB02BA.6030909@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Anthony Liguori wrote:
>   
>> Yeah, see, the initial goal was to make it possible to use the KVM
>> paravirtualizations on other hypervisors.  However, I don't think this
>> is really going to be possible in general so maybe it's better to just
>> use leaf 0.  I'll let others chime in before sending a new patch.
>>     
>
> Hm.  Obviously you can just define a signature for "kvm-compatible
> hypercall interface" and make it common that way, but it gets tricky if
> the hypervisor supports multiple hypercall interfaces, including the kvm
> one.  Start the kvm leaves at 0x40001000 or something?
>   

Yeah, that works with me.

Regards,

Anthony Liguori

>     J
>
>   

