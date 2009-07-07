Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZGGSY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZGGSY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 14:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZGGSYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 14:24:19 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4743 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZGGSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 14:24:19 -0400
Message-ID: <4A5392CB.9090306@xs4all.nl>
Date: Tue, 07 Jul 2009 20:24:11 +0200
From: Rambaldi <rambaldi@xs4all.nl>
User-Agent: Thunderbird 2.0.0.22 (X11/20090628)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: kernel BUG at arch/x86/xen/multicalls.c:204!
References: <4A20F23D.4080504@xs4all.nl> <4A21CE1C.1090204@goop.org> <4A222E7C.3030504@xs4all.nl>
In-Reply-To: <4A222E7C.3030504@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rambaldi wrote:
> Jeremy Fitzhardinge wrote:
>> Rambaldi wrote:
>>> Hi,
>>>
>>> while booting the 2.6.29-gentoo-r5 kernel as xen domU guest I got the
>>> following kernel BUG.
>>>
>>> I have not tried a vanilla 2.6.29 kernel, but can if requested,
>>> .config is also available on reguest.
>>>   
>> That would be useful, particularly if you enable the various debugging
>> options:
>> CONFIG_DEBUG_KERNEL
>> CONFIG_FRAME_POINTER
>>
>> It's not clear to me what's failing.  Are there any messages on the Xen
>> concole (xm dmesg)?
>>
>>    J
>>
> Hi Jeremy,
> 
> thanks for looking at it.
> 
> I tried with a vanilla 2.6.29.4 kernel. I added CONFIG_FRAME_POINTER. CONFIG_DEBUG_KERNEL was already set.
> I got the same result as with the gentoo kernel and in both cases not a single line in the xen console.
> 
> Any other options or kernels I can try?
> 
> tia
> 
> R
> 

Hi Again,

it has been a while, but I finally found the setting that caused this issue.
by removing:
	Configure Maximum number of SMP Processors and NUMA Nodes

I can boot my sytem again without the kernel BUG.

hope this helps

regards.

R.







