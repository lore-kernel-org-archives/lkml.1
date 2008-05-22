Return-Path: <linux-kernel-owner+w=401wt.eu-S937732AbYEVAes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937732AbYEVAes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937259AbYEVAe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:34:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36089 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937146AbYEVAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:34:26 -0400
Message-ID: <4834BE63.3060305@oracle.com>
Date: Wed, 21 May 2008 17:29:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: mark <markkicks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>	 <20080521132845.72db5748.randy.dunlap@oracle.com>	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>	 <48348AFA.1070900@oracle.com>	 <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>	 <20080521143248.baee1391.randy.dunlap@oracle.com>	 <82fa9e310805211551oea0dfd9mdb7dfaed2b2d98fc@mail.gmail.com>	 <20080521163503.000afd61.randy.dunlap@oracle.com> <82fa9e310805211709i3993cac2n58152cf11a3ef8a4@mail.gmail.com>
In-Reply-To: <82fa9e310805211709i3993cac2n58152cf11a3ef8a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark wrote:
> On Wed, May 21, 2008 at 4:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> I can send you some debug patches that will print out the specific
>>>> problem area.  Do you want to do that?  Can you rebuild and install
>>>> a new kernel?
>>> Is it possible to get this debug messages by turning on some flags?
>>> If not yes, pl. send debug patches. its a live box and  I will try to do it!
>>>
>>> This is my system / kernel info:
>>> uname -a
>>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>>> x86_64 x86_64 x86_64 GNU/Linux
>> I made a small patch to a vanilla kernel.org 2.6.25.3 kernel tree.
>> Hopefully it applies cleanly to that fc9 kernel source, but check/verify
>> that first before going any further.
> 
> Thanks a lot for the patch,
> This is kind of weird..  but there is no file  kernel/fork.c
> 
> [mark@localhost 2.6.25.3-18.fc9.i686]$ find . -iname '*fork*' -print
> [mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql
> [mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql kernel-devel | grep fork
> [mark@localhost 2.6.25.3-18.fc9.i686]$ pwd
> /usr/src/kernels/2.6.25.3-18.fc9.i686

That's not a kernel source tree.

I'm no expert on fc nor on src.rpm's, but I think that you need to get
the fc kernel-2.6.25.3-18.src.rpm file (or something like that).

Or use a plain vanilla kernel.org 2.6.25.3 kernel tree.

-- 
~Randy
