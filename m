Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbZEGMP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbZEGMP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZEGMPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:15:47 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:26016
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753941AbZEGMPq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:15:46 -0400
X-BigFish: VPS-33(zz1432R98dR936eQ1805M936fJzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KJ9WPX-02-90E-01
Date: Thu, 7 May 2009 14:15:35 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507121535.GH4059@amd.com>
References: <20090428150531.GZ17438@amd.com> <1240932530.2567.91.camel@macbook.infradead.org> <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com> <1241691721.3531.73.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1241691721.3531.73.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 May 2009 12:15:35.0464 (UTC) FILETIME=[867D1A80:01C9CF0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 11:22:01AM +0100, David Woodhouse wrote:
> On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
> > > Looks like the DRM code uses the DMA API.
> > 
> > The proprietary drivers make problems so far. For the ATI one I am in
> > contact with the developers to try to fix it. But I can't do anything
> > about the other proprietary driver I am aware of :-(
> 
> I see no harm in "breaking" code which was already broken. If that's the
> only reason we're enabling the graphics workaround, let's turn it off.

Well, it is not that simple. Having no workaround at all will not result
in working proprietary drivers. More likely is that distros just disable
the IOMMU because their customers want to use these drivers for working
3d acceleration.
As I wrote in the original mail I think we should just make sure that
these drivers still work with an IOMMU without disabling device
isolation.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

