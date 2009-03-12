Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbZCLMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbZCLMyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZCLMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:54:06 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17520
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752114AbZCLMyF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:54:05 -0400
X-BigFish: VPS-33(z6cekz1432R98dR936eQ1805M936fKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KGE95Q-01-5V4-01
Date: Thu, 12 Mar 2009 13:53:52 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090312125352.GG20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com> <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com> <20090312114121.GF20716@alberich.amd.com> <1236860942.12514.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236860942.12514.1.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Mar 2009 12:53:53.0413 (UTC) FILETIME=[990A4B50:01C9A311]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 02:29:02PM +0200, Maxim Levitsky wrote:
> On Thu, 2009-03-12 at 12:41 +0100, Andreas Herrmann wrote:
> >  (Causing Suspend/resume problem:)
> > - Acer Ferrari 1000
> > - Acer Ferrari 5000

> What problem?
> Hang second resume???

See

  http://lkml.org/lkml/2007/4/3/110

I don't have access to such a machine. Thus I don't know
what the exact problem was.

But it was the reason that the code to sync RdMem/WrMem bits of
fixed-MTRRs on AMD-CPUs was added. And now this caused new problems on
systems with other buggy BIOSes.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


