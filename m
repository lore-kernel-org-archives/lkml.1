Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbZLPRp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbZLPRp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZLPRp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:45:26 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:6751 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751715AbZLPRpY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:45:24 -0500
X-SpamScore: -33
X-BigFish: VPS-33(zz1432R98dN14ffO936eM9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KURANA-02-ETN-02
X-M-MSG: 
Date: Wed, 16 Dec 2009 18:45:24 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 16 (amd64_edac)
Message-ID: <20091216174524.GH11618@aftab>
References: <20091216183212.118c5e14.sfr@canb.auug.org.au>
 <20091216092424.5f87214c.randy.dunlap@oracle.com>
 <4B2919BD.40001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B2919BD.40001@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Dec 2009 17:45:12.0042 (UTC) FILETIME=[845DACA0:01CA7E77]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:32:45AM -0800, H. Peter Anvin wrote:
> On 12/16/2009 09:24 AM, Randy Dunlap wrote:
> > On Wed, 16 Dec 2009 18:32:12 +1100 Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> My usual call for calm: please do not put stuff destined for 2.6.34 into
> >> linux-next trees until after 2.6.33-rc1.
> >>
> >> Changes since 20091215:
> > 
> > 
> > When CONFIG_SMP=n, CONFIG_X86_MSR=m:
> > 
> > ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
> > ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!
> > 
> > 
> > Should EDAC_AMD64 also depend on SMP?
> > 
> 
> That seems absurd... more likely msrs_free/msrs_alloc should not be
> SMP-specific, or stubs need to be provided.

see <arch/x86/lib/Makefile>:

obj-$(CONFIG_SMP) := msr.o

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

