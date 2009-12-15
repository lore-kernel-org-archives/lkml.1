Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZLOTpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZLOTpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbZLOTpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:45:45 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:22198
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753817AbZLOTpo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:45:44 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KUPLJS-01-A4E-02
X-M-MSG: 
Date: Tue, 15 Dec 2009 20:45:36 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] x86, amd: Get multi-node CPU info from NodeId
 MSR instead of PCI config space
Message-ID: <20091215194536.GC10747@aftab>
References: <20091215124418.GA6414@alberich.amd.com>
 <20091215193150.GE15443@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091215193150.GE15443@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Dec 2009 19:45:25.0585 (UTC) FILETIME=[258F3C10:01CA7DBF]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:31:50PM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:
> 
> > +	rdmsrl(0xc001100c, value);
> 
> Dont we want some nice, meaningfully named symbolic constant here, instead of 
> 0xc001100c?

The MSR name is actually in the commit msg, maybe something like
MSR_F10H_NODE_ID.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

