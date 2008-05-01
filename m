Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYEAJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYEAJIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYEAJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:08:07 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:22461 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYEAJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:08:06 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: jclyXLBJ10ZHTmMMskdeEV9K+qamm4K24+0GzTHYHnheuzKtvddXf0g46u47Uw==
Message-ID: <48198873.7030503@hartkopp.net>
Date: Thu, 01 May 2008 11:08:03 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>
In-Reply-To: <4819050C.9060800@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Oliver Hartkopp wrote:
>> i wonder about the Kernel naming convention in the merge phase before
>> the -rc1 is officially tagged by Linus.
>>
>> Won't it be more precisely to name the current snapshot
>> 2.6.26-merge-git16 instead of 2.6.25-git16?
>>
>> It is not that i would suggest to have a new git tag in this merge 
>> phase but only the Makefile should be changed at the beginning of 
>> this phase to identify the ongoing work for the 2.6.26:
>>
>> (..)
>>
>> Introducing the new '-merge' version _that_ early helps to avoid the 
>> version confusion in /lib/modules and also allows people to work with 
>> kernel version depended stuff in a very early phase.
>>
>
> And it'll break all the robotic stuff again.
>
> Foo-gitX has always been a development snapshot which *follows* Foo.

Hm - if it breaks the robotic stuff, there could be a real 
"v2.6.26-merge" git tag which shouldn't break like "v2.6.26-rc1".

It could look like this:

- tag v2.6.25
- drink a beer
- tag v2.6.26-merge
- pull the new stuff from subsystem maintainers
- tag v2.6.26-rc1
- ...

For me a 2.6.25-gitX looks like a snapshot that leads to a 2.6.25.1 and 
_not_ to a 2.6.26-rc1. The current 2.6.25-git16 is moch more a 2.6.26 
than a 2.6.25. So v2.6.26-merge-git16 makes it much clearer what's going 
on here.

To tag Linus' tree with v2.6.26-merge before pulling all the new 2.6.26 
stuff seems therefore reasonable to me. But maybe i don't have all the 
dependencies on my radar.

Regards,
Oliver

