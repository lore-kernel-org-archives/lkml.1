Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZHMMXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZHMMXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZHMMXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:23:48 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27172 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZHMMXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:23:47 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz98dN148cMzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KOBEFA-04-5FJ-01
Date: Thu, 13 Aug 2009 14:23:37 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090813122337.GB7029@aftab>
References: <4A7E0797.7060504@gmail.com>
 <20090810131219.GD21879@aftab>
 <4A80A5AD.2000209@gmail.com>
 <19073.33348.459260.456740@pilspetsen.it.uu.se>
 <20090811155106.GB16173@aftab>
 <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
 <20090811160116.GD16173@aftab>
 <4A8209B6.8050306@gmail.com>
 <20090812114038.GD15396@aftab>
 <4A8349F6.9080107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A8349F6.9080107@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 13 Aug 2009 12:23:34.0416 (UTC) FILETIME=[E072E100:01CA1C10]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Wed, Aug 12, 2009 at 08:02:14PM -0300, Kevin Winchester wrote:
> So that feature is definitely set.

thanks for testing. As a reply to that follow two patches for you to
test. The one is adding some more msr functionality and the second is
based on your original one which should in addition turn off the cpuid
bit. Please apply, compile, reboot and run the small app again to verify
that ECX[0] is now off.

Let me know how it goes.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

