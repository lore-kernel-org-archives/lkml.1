Return-Path: <linux-kernel-owner+w=401wt.eu-S933210AbZIDI2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbZIDI2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933125AbZIDI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:27:59 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:1345 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932685AbZIDI15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:27:57 -0400
X-SpamScore: -10
X-BigFish: VPS-10(z34a4jz1432R98dNa594izz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPFU6D-03-M9S-01
Date: Fri, 4 Sep 2009 10:27:09 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, petkovbb@googlemail.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset
 registers
Message-ID: <20090904082709.GA28389@aftab>
References: <20090831073429.GA26596@liondog.tnic>
 <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
 <20090903155539.ecd64bcd.akpm@linux-foundation.org>
 <4AA049F2.5000403@zytor.com>
 <20090903161426.cc441294.akpm@linux-foundation.org>
 <20090904063904.GA29829@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090904063904.GA29829@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Sep 2009 08:26:57.0350 (UTC) FILETIME=[776D0660:01CA2D39]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 08:39:04AM +0200, Ingo Molnar wrote:
> > I want my five minutes back.
> 
> I too want my five minutes back that i spent researching commit logs 
> and writing this email ;-)
> 
> Btw., we could save much more if we avoided this whole 'break the 
> kernel then fix it' infinite loop that kernel development is 
> ultimately about ;-)

Well,

how about I buy you all coffee instead :-). The :req thing was my
overzealous attempt to write asm macros - I promise I won't do it
anymore :-).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

