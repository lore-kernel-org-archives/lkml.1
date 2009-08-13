Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZHMQTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZHMQTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZHMQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:19:31 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31342 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZHMQTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:19:31 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOBPBS-01-C9N-02
X-M-MSG: 
Date: Thu, 13 Aug 2009 18:18:54 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Brian Gerst <brgerst@gmail.com>
CC: Kevin Winchester <kjwinchester@gmail.com>, mikpe@it.uu.se, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090813161854.GB8534@aftab>
References: <20090813122337.GB7029@aftab>
 <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
 <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
 <d1af83620908130754i7db4bd33p26cd54d0c30d68a5@mail.gmail.com>
 <73c1f2160908130855h128c9908h486d583ee9fdcea5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <73c1f2160908130855h128c9908h486d583ee9fdcea5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Aug 2009 16:18:51.0580 (UTC) FILETIME=[BEEF27C0:01CA1C31]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:55:32AM -0400, Brian Gerst wrote:

[..]

> > Possibly.  If there were some concern that:
> >
> > - The extra instructions would cause a performance impact, and the
> > test was significantly faster than the clear.
> 
> Testing a bit is cheap and MSR accesses are not.

true.
 
> > - The extra instructions might actually cause more problems if the
> > flag is not set.
> 
> These MSRs don't exist on older cpus and will cause a fault, which is
> handled at additional cost.

No, we're ok here since this code is exec'ed on K8s only. The _safe
variants are an additional precaution only.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

