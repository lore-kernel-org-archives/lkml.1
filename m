Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077Ab0A1NZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0A1NZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770Ab0A1NZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:25:27 -0500
Received: from mx2.compro.net ([12.186.155.4]:3357 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab0A1NZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:25:26 -0500
X-IronPort-AV: E=Sophos;i="4.49,359,1262581200"; 
   d="scan'208";a="4920709"
Message-ID: <4B619043.1070806@compro.net>
Date: Thu, 28 Jan 2010 08:25:23 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: dmarkh@cfl.rr.com, Yuhong Bao <yuhongbao_386@hotmail.com>,
       venkatesh.pallipadi@intel.com, andi@firstfloor.org,
       Linus Torvalds <torvalds@linux-foundation.org>, alain@knaff.lu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com> <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <4B61562C.1010103@cfl.rr.com>
In-Reply-To: <4B61562C.1010103@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 04:17 AM, Mark Hounschell wrote:
> On 01/25/2010 12:10 PM, Andreas Herrmann wrote:
>> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
>>>
>>>> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
>>>> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
>>
>> Argh, will see what information I can find about this problem ...
>>
>>> I think somebody from AMD should review the situation.Clearly
>>   something is happening inside their southbridge.CCing Andreas
>>   Herrmann from AMD.
>>
>> I have the feeling that this problem should rather be fixed with a DMI
>> quirk instead of disabling HPET MSI for the entire chipset.
>>
>> Was the latest available BIOS installed on the affected system?
>>
> 
> You mean "systems" of different manufactures?  I will check today. Due to
> mis configured filters I didn't see this until today. Sorry.
> 
> Mark
> 

My BIOS were below rev on all my affected boards but updating did not help
with the problem.

Andreas, while I have your ear, I am also having another issue with this
chip set doing peer to peer bus transfers between pci buses and pci-e buses
and from pci-e to pci-e buses. I've read the chip set specs and they _seem_
to imply that it may not be allowed due to "Trusted Computing" something or
another. I've posed the issue to the AMD forums with no luck, and
I can't figure out why this doesn't work using these chip sets.

Sorry to change the subject. I just figured I'd ask someone from AMD while
I had the chance.

Thanks and Regards
Mark
