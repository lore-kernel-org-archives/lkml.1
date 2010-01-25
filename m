Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342Ab0AYRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0AYRLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302Ab0AYRLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:11:20 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:22648
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754300Ab0AYRLT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:11:19 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432R98dN4015Lzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWTBQA-02-8UA-02
X-M-MSG: 
Date: Mon, 25 Jan 2010 18:10:59 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: venkatesh.pallipadi@intel.com, markh@compro.net, dmarkh@cfl.rr.com,
       andi@firstfloor.org, Linus Torvalds <torvalds@linux-foundation.org>,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100125171059.GB5041@alberich.amd.com>
References: <87bphpd4rt.fsf@basil.nowhere.org>
 <4B32565E.6000501@compro.net>
 <20091223191806.GA3336@linux-os.sc.intel.com>
 <4B3270FE.5090607@compro.net>
 <1261600243.16916.56.camel@localhost.localdomain>
 <4B476E8D.1030308@compro.net>
 <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Jan 2010 17:10:59.0815 (UTC) FILETIME=[5DAAAF70:01CA9DE1]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
> 
> > HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
> > side-effects on floppy DMA. Do not use HPET MSI on such platforms.

Argh, will see what information I can find about this problem ...

> I think somebody from AMD should review the situation.Clearly
  something is happening inside their southbridge.CCing Andreas
  Herrmann from AMD.

I have the feeling that this problem should rather be fixed with a DMI
quirk instead of disabling HPET MSI for the entire chipset.

Was the latest available BIOS installed on the affected system?


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


