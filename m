Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXETNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXETNPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXETNPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:15:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXETNPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:15:05 -0400
Message-ID: <465049BE.5000000@cv-sv.de>
Date: Sun, 20 May 2007 15:14:38 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Claas Langbehn <claas@rootdir.de>
CC: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: Via C3/C7: other flags possible ?
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <464F332C.8060904@rootdir.de> <464F5C8F.5000304@cv-sv.de> <464F7C09.8060809@cv-sv.de> <464F7F90.2000900@simon.arlott.org.uk> <4650047F.4000804@rootdir.de>
In-Reply-To: <4650047F.4000804@rootdir.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19bF6s3yWsBcUSz92AFqIDs/eJ0WYAWVai56nZ
 wR3dBjeXUU5P+YEJ78Xg+h8wPAKzU1+szLKUm+qwYWFTlLBRGA
 61DevLLcICxbD73/Ofl+w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bit 20 in edx is set if NX is available for C7:

eax in: 0x80000001, eax = 00000000 ebx = 00000000 ecx = 00000000 edx = 00100000
( from your posting "This kernel requires the following..." )

The official VIA Eden  datasheet seems to be NDA. I have not found any
official download link on the pages:
http://www.via.com.tw/en/products/processors/c7/
The /c3/ pages contain the documentation  for the C3 family.

I do not think the NX feature can be switched on/off by regular registers.

May be it helps to play around with the bios ?
Load "default settings" => see how the NX flag acts.
Load "optimized settings" => see how the NX flags acts.

I suppose the bios developer had used one setting to test and
work with the NX flag regular.

Christian


> If you read the other thread properly you'd see that the BIOS has an option to enable or disable it... when enabled it shows up.
PS: @Simon, sorry that I missed the other thread. Too much traffic
and not enough time for me to read all. I suppose that's a fulltime job ;-)

Claas Langbehn wrote:
> Simon Arlott schrieb:
>> On 19/05/07 23:36, Christian Volkmann wrote:
>>> Christian Volkmann wrote:
>>>> Claas asked for the NX flag for the Via C3 (?) processors
>>>> in another thread.
>>
>> If you read the other thread properly you'd see that the BIOS has an
>> option to enable or disable it... when enabled it shows up.
> 
> Right, but my bios disables this after each boot-time :(
> Therefore it would be great if the kernel would not care
> about the BIOS and enable it anyway.
> 
> This seems to be a severe bug in the BIOS, but VIA does not
> deliver a new BIOS since months. :(
> 
>>
>> I can't reboot that box just to test cx8 detection (which is missing).
>>
> It works here.
> 
> 
> 
> claas
> 

