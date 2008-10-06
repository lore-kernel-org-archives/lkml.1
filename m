Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754393AbZALHEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZALHEQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Mon, 12 Jan 2009 02:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZALHD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:03:57 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:35547 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751556AbZALHD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:03:56 -0500
Message-ID: <48E9B842.1020303@snapgear.com>
Date: Mon, 06 Oct 2008 17:03:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, dhowells@redhat.com
Subject: Re: [PATCH] get rid of the last symlink in uml build
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org> <20081217170257.GE28946@ZenIV.linux.org.uk> <20081217171800.GA5436@uranus.ravnborg.org>
In-Reply-To: <20081217171800.GA5436@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Sam Ravnborg wrote:
> On Wed, Dec 17, 2008 at 05:02:57PM +0000, Al Viro wrote:
>> 	BTW, after taking a look at the remaing asm-*...
>>
>> * frv, m32r and h8300 should be as trivial as git mv
> 
> Yep - I already have positive feedback from arch maintainers that
> they will fix it in the -rc1 timeframe.
> 
>> * m68k has a bit of extra PITA - we need to clean up two non-trivial
>>   includes from m68knommu (pci.h and setup.h) first, then it's a matter
>>   of git mv, adding arch/m68k/include to search path on m68knommu and
>>   removal of dummy headers from the latter.
> 
> I took a different route here and unified the headers for m68k and m68knommu
> under arch/m68k/include/asm
> It was based on a script originally developed by Arnd Bergmann.
> 
> Geert already acked it, and I expect Greg to apply it in the -rc1 timeframe.

I have been away for the last few weeks, so I haven't looked at this
at all yet. I will over the next few days though.

Regards
Greg



> http://marc.info/?l=linux-kbuild&m=122927123805002&w=2 has Geert's ack,
> but original patch did not hit marc?!?
> 
>> * xtensa is already moved in linux-next
> Yes.
> 
> 
>> * arm seems to be lacking the final push for few remaining headers; presumably
>>   will happen eventually
> rmk knows it and takes care.
> 
>> * mn10300 is playing with symlinks - the last one to do that for headers,
>>   AFAICS.
>>
>> I've thrown together a patch series on top of linux-next doing m68k and
>> mn10300.  *WARNING* - it's completely untested, basically about half an
>> hour diversion from sifting through the mailbox for missed VFS patches.
>> And that half and hour did *not* include anything resembling building
>> the resulting tree.  So take that with a trainload of salt.
> Thanks Al.
> I will take a closer look at the mn10300 bits and send them to David
> in due time.
> 
> 	Sam
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
