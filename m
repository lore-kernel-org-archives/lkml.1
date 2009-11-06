Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZKFNUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZKFNUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZKFNUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:20:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38472 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbZKFNUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:20:08 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KSOVPE-02-CB7-02
X-M-MSG: 
Date: Fri, 6 Nov 2009 14:20:19 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, Doug Thompson <norsk5@yahoo.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] amd64_edac: syndromes loading
Message-ID: <20091106132019.GB30030@aftab>
References: <20091028163534.GA625@aftab>
 <143841.81095.qm@web50110.mail.re2.yahoo.com>
 <20091028172853.GE625@aftab>
 <20091101211305.GB2085@ucw.cz>
 <4AEE0CAA.4070403@zytor.com>
 <20091105132758.GC17984@aftab>
 <20091105221725.GA3683@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091105221725.GA3683@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Nov 2009 13:20:01.0608 (UTC) FILETIME=[D87C1C80:01CA5EE3]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 11:17:25PM +0100, Pavel Machek wrote:
> > The good news is they've come up with a modified algorithm which will
> > require a smaller table, roughly 1/4th the size of the current 10K one.
> > Now, on a second thought and IMHO, we should simply add another .c file
> > instantiating those two x4 and x8 tables statically and linking them
> > into the edac code. This way you
> > 
> > 1) don't have the additional complexity of adding firmware handling code
> > and thus don't add a dependency on the firmware API
> > 
> > 2) don't have to actually carry two firmware images with the kernel
> 
> Well, that's certainly better than current situation.

Looks like we might have a much more elegant solution eliminating the
need for big tables and firmware images. Stay tuned while we're figuring
out the details.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

