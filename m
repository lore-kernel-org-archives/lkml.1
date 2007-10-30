Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXJ3Lji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXJ3Lji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXJ3Ljb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:39:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:33928 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXJ3Lja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:39:30 -0400
Message-ID: <4727178F.8040005@qumranet.com>
Date: Tue, 30 Oct 2007 13:37:51 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm-devel@lists.sourceforge.net, Carsten Emde <Carsten.Emde@osadl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>	<4726B088.1010709@qumranet.com>	<4726DF66.4000000@osadl.org> <4726FE2A.1040607@siemens.com> <47271057.5040102@qumranet.com> <472716C1.1090102@siemens.com>
In-Reply-To: <472716C1.1090102@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Avi Kivity wrote:
>   
>> Jan Kiszka wrote:
>>     
>>> Interesting result - you've read about the wbinvd issues? Is there no
>>> wbinvd in the bios shipped with older kvm? Which VM extension did you
>>> test, both Intel and AMD? I would bet that your X issues are due to the
>>> same effect. X startup/shutdown involves a lot of wbinvd calls on my
>>> test boxes.
>>>
>>>   
>>>       
>> kvm.git now traps invd and wbinvd on amd, so there shouldn't be any 
>> issues there. 
>>     
>
> So kvm can then simply ignore the instructions, or what does it do about
> them? I recall some replies in the related thread that some more work
> may be required.
>
>   

It currently ignores the instructions.  When device passthrough is 
implemented more work will be needed.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

