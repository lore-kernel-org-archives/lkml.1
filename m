Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077Ab0A1JRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0A1JRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492Ab0A1JRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:17:38 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:46116 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab0A1JRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:17:37 -0500
X-Authority-Analysis: v=1.0 c=1 a=025kDFZZ1tQA:10 a=oPbTOnmd-kg4LKndnMYA:9 a=efHbo4k_wN11fjo5kGQ0Edo4RuEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B61562C.1010103@cfl.rr.com>
Date: Thu, 28 Jan 2010 04:17:32 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, andi@firstfloor.org,
       Linus Torvalds <torvalds@linux-foundation.org>, alain@knaff.lu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com> <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com>
In-Reply-To: <20100125171059.GB5041@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 12:10 PM, Andreas Herrmann wrote:
> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
>>
>>> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
>>> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
> 
> Argh, will see what information I can find about this problem ...
> 
>> I think somebody from AMD should review the situation.Clearly
>   something is happening inside their southbridge.CCing Andreas
>   Herrmann from AMD.
> 
> I have the feeling that this problem should rather be fixed with a DMI
> quirk instead of disabling HPET MSI for the entire chipset.
> 
> Was the latest available BIOS installed on the affected system?
> 

You mean "systems" of different manufactures?  I will check today. Due to
mis configured filters I didn't see this until today. Sorry.

Mark
