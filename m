Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524Ab0A1OpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0A1OpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A1OpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:45:09 -0500
Received: from mx2.compro.net ([12.186.155.4]:25348 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0A1OpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:45:08 -0500
X-IronPort-AV: E=Sophos;i="4.49,359,1262581200"; 
   d="scan'208";a="4921008"
Message-ID: <4B61A2F1.4090605@compro.net>
Date: Thu, 28 Jan 2010 09:45:05 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, dmarkh@cfl.rr.com,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       andi@firstfloor.org, Linus Torvalds <torvalds@linux-foundation.org>,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
References: <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com> <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <4B61562C.1010103@cfl.rr.com> <4B619043.1070806@compro.net> <20100128134109.GE26322@aftab>
In-Reply-To: <20100128134109.GE26322@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 08:41 AM, Borislav Petkov wrote:
> On Thu, Jan 28, 2010 at 08:25:23AM -0500, Mark Hounschell wrote:
>> On 01/28/2010 04:17 AM, Mark Hounschell wrote:
>>> On 01/25/2010 12:10 PM, Andreas Herrmann wrote:
>>>> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
>>>>>
>>>>>> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
>>>>>> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
>>>>
>>>> Argh, will see what information I can find about this problem ...
>>>>
>>>>> I think somebody from AMD should review the situation.Clearly
>>>>   something is happening inside their southbridge.CCing Andreas
>>>>   Herrmann from AMD.
>>>>
>>>> I have the feeling that this problem should rather be fixed with a DMI
>>>> quirk instead of disabling HPET MSI for the entire chipset.
>>>>
>>>> Was the latest available BIOS installed on the affected system?
>>>>
>>>
>>> You mean "systems" of different manufactures?  I will check today. Due to
>>> mis configured filters I didn't see this until today. Sorry.
>>>
>>> Mark
>>>
>>
>> My BIOS were below rev on all my affected boards but updating did not help
>> with the problem.
> 
> Hi,
> 
> can you post the BIOS vendors of the boards along with the respective
> BIOS versions?
> 
> Thanks.
> 

DFI  DK-790FXB-M3H5 MB using AWARD bios D7SDA09.BIN (10/09/2009)
BIOSTAR TA790GXB A2+ using AMI bios 78DDA928.BST  (09/28/09)

Regards
Mark
