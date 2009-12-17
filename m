Return-Path: <linux-kernel-owner+w=401wt.eu-S1764038AbZLQHWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764038AbZLQHWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762133AbZLQHWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:22:30 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42640
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761208AbZLQHW3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:22:29 -0500
X-SpamScore: -34
X-BigFish: VPS-34(z21eWz1432R98dN179dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUSCH6-02-3I4-02
X-M-MSG: 
Date: Thu, 17 Dec 2009 08:22:32 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error
 with linux-2.6.32)
Message-ID: <20091217072232.GB4293@aftab>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
 <20091216164156.GF11618@aftab>
 <200912170407.04568.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200912170407.04568.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Dec 2009 07:22:18.0597 (UTC) FILETIME=[AA784950:01CA7EE9]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 04:07:04AM +0100, Johannes Hirte wrote:
> > > Disabling in BIOS doesn't made any difference. The errors were still
> > > reported.
> > 
> > Hmm. It would be interesting to know what the BIOS does exactly
> > on your machine. We could easily find that out by installing the
> > x86info tool (either prepackaged for your distro or from here:
> > git://git.choralone.org/git/x86info) and doing as root:
> > 
> > lsmsr MC4 -V3
> > 
> > and sending me the output. Make sure the amd64_edac module is not loaded.
> 
> datengrab ~ # lsmsr MC4 -V3    
> MC4_CTL              = 0x0000000000003bff
>   CorrEccEn=0x1                          
>   UnCorrEccEn=0x1                        
>   CrcErr0En=0x1                          
>   CrcErr1En=0x1                          
>   CrcErr2En=0x1                          
>   SyncPkt0En=0x1                         
>   SyncPkt1En=0x1
>   SyncPkt2En=0x1
>   MstrAbrtEn=0x1
>   TgtAbrtEn=0x1
>   GartTblWkEn=0

Was the BIOS setting about GART table walk errors reporting enabled or
disabled? Because if it were enabled and according to the above output,
your BIOS doesn't seem to do the workaround described in the BKDG. If it
were disabled, you'd have to enable it and do the "lsmsr MC4 -V3" again.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

