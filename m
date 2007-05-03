Return-Path: <linux-kernel-owner+w=401wt.eu-S1767373AbXECEZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767373AbXECEZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767374AbXECEZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:25:42 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45152 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767373AbXECEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:25:41 -0400
Message-ID: <463963AE.5010300@vmware.com>
Date: Wed, 02 May 2007 21:23:10 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Marcos Pinto <markybob@gmail.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: Mysterious RTC hangs on x86_64 - fixed, sort of
References: <46391253.30201@vmware.com> <46391716.9040001@redhat.com>
In-Reply-To: <46391716.9040001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>
>   
>> CONFIG_HPET_EMULATE_RTC=y
>>     
>
> Did you try without that?
>   

Just did.  Still hangs same way; strace shows /sbin/hwclock dying after 
hundreds of RTC_RD_TIME.  And now /proc/interrupts shows no rtc 
interrupts being generated (expected, I gues).  Seems to take longer to 
crash, but this is a heisenbug.

Enough crashing for today.  Strangest thing is the NMI watchdog does not 
fire...

Zach
