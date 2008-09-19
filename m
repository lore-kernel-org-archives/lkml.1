Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYISMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYISMAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYISMAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:00:07 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27700 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYISMAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:00:06 -0400
X-BigFish: VPS-31(zz1432R98dR4015M1805M936fQ873fnzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7FYNS-01-8QI-01
Message-ID: <48D3942B.1050901@amd.com>
Date: Fri, 19 Sep 2008 13:59:39 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, cate@debian.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to microcode_intel.c.
References: <20080728164411.490752571@amd.com>	<20080728164448.492961653@amd.com>	<20080907120823.59f8fa47@infradead.org>	<48CA586C.2010104@amd.com> <20080912063517.783b7f85@infradead.org>
In-Reply-To: <20080912063517.783b7f85@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 11:59:39.0710 (UTC) FILETIME=[31CE1DE0:01C91A4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some additonal words regarding the current user space issues:

IMHO the most convenient way to update microcode is through the firmware loading
interface instead of microcode_ctl. This reduces user-space responsibilities to
loading the correct module at boot time and to place the microcode patch file at
the right location via package installation. The problems mentioned in this
thread would then probably disappear as well. What do you guys think?

Thanks,
Peter

Arjan van de Ven schrieb:
> On Fri, 12 Sep 2008 13:54:20 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
> 
>> Arjan,
>>
>> could you please provide some more information about that issue?
> 
> well.. the fedora boot script just plain fails.
> I suspect it manually loads microcode.ko or something if CPUID says
> intel; and this now stops working...
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

