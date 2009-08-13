Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZHMPzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZHMPzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZHMPzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:55:05 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2113 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZHMPzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:55:03 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOBO7B-04-1TL-01
Date: Thu, 13 Aug 2009 17:54:49 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Brian Gerst <brgerst@gmail.com>
CC: kjwinchester@gmail.com, mikpe@it.uu.se, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090813155449.GA8534@aftab>
References: <20090813122337.GB7029@aftab>
 <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
 <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Aug 2009 15:54:50.0361 (UTC) FILETIME=[63E69690:01CA1C2E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:21:22AM -0400, Brian Gerst wrote:
> > +               /*
> > +                * Some BIOSes incorrectly force this feature, but only K8
> > +                * revision D (model = 0x14) and later actually support it.
> > +                */
> > +               if (c->x86_model < 0x14) {
> 
> Shouldn't you test that the flag is actually set before trying to clear it?

Yep, I'll do that in the final version of the patches.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

