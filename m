Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZA0QjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZA0QjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZA0QjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:39:03 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55660 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZA0QjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:39:01 -0500
X-BigFish: VPS-13(zz98dR936fMzzzzz32i6bh6di65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KE528G-02-M7N-01
Date: Tue, 27 Jan 2009 17:38:43 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <markh@compro.net>
CC: Mark Hounschell <dmarkh@cfl.rr.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090127163843.GA1628@aftab>
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <497E0072.7000500@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 Jan 2009 16:38:45.0476 (UTC) FILETIME=[B8C2BA40:01C9809D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 01:26:58PM -0500, Mark Hounschell wrote:

[.. ]

> If there is anything else I can try, I'm at your disposal.

Ok, I just boot-tested a 1000 HZ kernel here and I can't reproduce
your problem. Can you please send the failing .config. And also where
exactly does your kernel hang during the boot process, can you capture
any output and/or enable SysRq to dump backtrace on all cores (SysRq-T)
if possible. Finally, what does 'cat /proc/timer_list' on the working
kernel say?

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

