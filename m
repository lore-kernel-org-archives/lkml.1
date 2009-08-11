Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZHKMAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZHKMAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZHKMAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:00:41 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:33708 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZHKMAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:00:36 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R98dNzz1202hzz5a6ciz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO7HQI-04-8LX-01
Date: Tue, 11 Aug 2009 11:44:06 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090811094406.GA16173@aftab>
References: <4A7D673A.1090401@gmail.com>
 <20090808152016.GB25374@liondog.tnic>
 <4A7E0797.7060504@gmail.com>
 <20090810131219.GD21879@aftab>
 <4A80A5AD.2000209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A80A5AD.2000209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2009 09:44:08.0896 (UTC) FILETIME=[4620DC00:01CA1A68]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 07:56:45PM -0300, Kevin Winchester wrote:
> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
> need to force enable the LAHF_LM capability.  Unfortunately, in at
> least one case, the BIOS does this even for processors that do not
> support the functionality.
> 
> Add a specific check that will clear the feature bit for processors
> known not to support the LAHF/SAHF instructions.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

