Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165Ab0A1NlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0A1NlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089Ab0A1NlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:41:24 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12050 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0A1NlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:41:23 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWYM0N-01-JBC-02
X-M-MSG: 
Date: Thu, 28 Jan 2010 14:41:09 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <markh@compro.net>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, dmarkh@cfl.rr.com,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       andi@firstfloor.org, Linus Torvalds <torvalds@linux-foundation.org>,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100128134109.GE26322@aftab>
References: <4B32565E.6000501@compro.net>
 <20091223191806.GA3336@linux-os.sc.intel.com>
 <4B3270FE.5090607@compro.net>
 <1261600243.16916.56.camel@localhost.localdomain>
 <4B476E8D.1030308@compro.net>
 <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
 <20100125171059.GB5041@alberich.amd.com>
 <4B61562C.1010103@cfl.rr.com>
 <4B619043.1070806@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B619043.1070806@compro.net>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Jan 2010 13:41:08.0630 (UTC) FILETIME=[8BF99360:01CAA01F]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 08:25:23AM -0500, Mark Hounschell wrote:
> On 01/28/2010 04:17 AM, Mark Hounschell wrote:
> > On 01/25/2010 12:10 PM, Andreas Herrmann wrote:
> >> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
> >>>
> >>>> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
> >>>> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
> >>
> >> Argh, will see what information I can find about this problem ...
> >>
> >>> I think somebody from AMD should review the situation.Clearly
> >>   something is happening inside their southbridge.CCing Andreas
> >>   Herrmann from AMD.
> >>
> >> I have the feeling that this problem should rather be fixed with a DMI
> >> quirk instead of disabling HPET MSI for the entire chipset.
> >>
> >> Was the latest available BIOS installed on the affected system?
> >>
> > 
> > You mean "systems" of different manufactures?  I will check today. Due to
> > mis configured filters I didn't see this until today. Sorry.
> > 
> > Mark
> > 
> 
> My BIOS were below rev on all my affected boards but updating did not help
> with the problem.

Hi,

can you post the BIOS vendors of the boards along with the respective
BIOS versions?

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

