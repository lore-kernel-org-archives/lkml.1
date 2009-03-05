Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZCEOBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZCEOBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbZCEOBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:01:24 -0500
Received: from gw-ca.panasas.com ([209.116.51.66]:28842 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbZCEOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:01:24 -0500
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 09:01:24 EST
Message-ID: <49AFD780.8080500@panasas.com>
Date: Thu, 05 Mar 2009 15:45:36 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export
 was in vmlinux
References: <49AFC206.9080004@panasas.com> <20090305130610.GA4265@hack.private>
In-Reply-To: <20090305130610.GA4265@hack.private>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Mar 2009 13:46:11.0142 (UTC) FILETIME=[BE617E60:01C99D98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Thu, Mar 05, 2009 at 02:13:58PM +0200, Boaz Harrosh wrote:
>> On today's linus v2.6.29-rc7-3-g559595a
>>
>> Doing make ARCH=um defconfig & make ARCH=um
>> give's me:
>>
>> LD vmlinux.o
>> MODPOST vmlinux.o
>> WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux
>>
>>
>> Sorry if this is a duplicate report
>>
> 
> Weird...
> I tried to compile like what you said, I can't reproduce it.
> 
> Which gcc are you using?
> 
> Thanks.
> 

$ gcc --version
gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)

I'm running on an x86_64 Fedora10 system (updated recently)
$ uname -o -s -r -m -p -i
Linux 2.6.27.15-170.2.24.fc10.x86_64 x86_64 x86_64 x86_64 GNU/Linux

Thanks
