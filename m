Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZBIOTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZBIOTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZBIOTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:19:04 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:50905 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZBIOTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:19:00 -0500
X-BigFish: VPS-43(zz1432R9370P98dR936eQ1805M936fMzzzzz32i6bh6di43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KESYF8-02-67F-01
Date: Mon, 9 Feb 2009 15:18:41 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: markh@compro.net, Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090209141841.GA31643@aftab>
References: <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <498CB798.7050308@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 09 Feb 2009 14:18:45.0232 (UTC) FILETIME=[5131F700:01C98AC1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 06, 2009 at 05:20:08PM -0500, Mark Hounschell wrote:
> Mark Hounschell wrote:
> >> Borislav Petkov wrote:
> >>> Ok, here are two things you could try:
> >>>
> >>> Disable CONFIG_HIGH_RES_TIMERS (high resolution timers support in
> >>> "Processor type and features"), boot with "apic=debug" and send me the
> >>> output. I'd like to see how the lapic timer gets programmed. It would
> >>> be better for that exercise to get the latest stable kernel, 2.6.28.3,
> >>> imho.
> >>>
> >>> The other thing you could do is get x86info tools from here:
> >>> http://www.codemonkey.org.uk/projects/x86info/. However, get either a
> >>> daily snapshot or a checkout from the git repository and build it on
> >>> your system. Then do
> >>>
> >>> x86info -a > x86info.txt
> >>>
> >>> lsmsr -V3 -a > lsmsr.txt
> >>>
> >>> and send me those text files - we might be able to get a clue what's going on
> >>> from them.
> > 
> > Ok, attached is the bootlog.txt, x86info.txt, and lsmsr.txt
> > 
> > Thanks
> > Mark
> > 
> 
> That bootlog was captured from the serial console, but comparing it to the dmesg
> I see more info in the dmesg. The extra stuff for "apic=debug" must not be going
> to the serial console?? Either way here is the demsg output too.
> 
> Regards
> Mark
> 

> BIOS EBDA/lowmem at: 0009f000/0009f000
> Initializing cgroup subsys cpuset
> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Fri Feb 6 11:48:54 EST 2009

maybe I wasn't clear enough - I meant to boot a _1000HZ_ kernel not a
250HZ one with highres timers disabled, if the line above is correct.
Can you try the same thing as above again, please, but this time use a
1000HZ 32bit kernel.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

