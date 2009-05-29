Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZE2KeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZE2KeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZE2KeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:34:05 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16809
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753979AbZE2KeE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:34:04 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dR1805M873fnzz1202hzzz32i6bh17ch6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKEIO8-01-4U0-01
Date: Fri, 29 May 2009 12:33:29 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090529103329.GB23530@aftab>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090528164720.0af5752b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 29 May 2009 10:33:30.0496 (UTC) FILETIME=[E8CFA800:01C9E048]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 28, 2009 at 04:47:20PM -0700, Andrew Morton wrote:
> On Wed, 20 May 2009 20:43:53 +0200
> Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > here are some minor fixlets which came up lately. I'm sending them
> > separately as an offset from the rest of the patchset since nothing has
> > changed there. For details, see
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next
> 
> My linux-next x86_64 allmodconfig fails to build drivers/edac/amd64_edac.o:
> 
> {standard input}: Assembler messages:
> {standard input}:3026: Error: no such instruction: `popcnt %eax,%ecx'

I guess this is a rather old(er) toolchain you got there. What do

as --version
gcc --version

say?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

