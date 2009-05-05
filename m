Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZEEWKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZEEWKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZEEWJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:09:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:59662 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbZEEWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:09:53 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>
	 <20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 05 May 2009 15:09:54 -0700
Message-Id: <1241561394.8665.31.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-05 at 14:44 -0700, Alan Cox wrote:
> > What is the benefit of this?
> 
> I believe the "benefit" is that a certain posters proprietary
> virtualisation product works better.

Hi Alan, 

I posted numbers that I had, and I don't think that the problem is
limited just to virtualization or our platform. 

> > I can see at least one immediate downside: some timeout values in the 
> > kernel are still maintained in units of HZ (like poll, I believe), and 
> > so with a lower HZ value we'll have higher roundoff errors.
> 
> And HZ=100 actually causes real problems for some video work (not in
> Europe where its just peachy). We switched to 1000Hz a very long time ago
> because it improved desktop feel and responsiveness. We switched to
> tickless to keep that behaviour with good power and idle behaviour.

IMO, one of the main motives of HRT implementation apart from getting
higher precision timers was that we now don't necessarily need to rely
on a high timer frequency. If you see problems with Desktop feel and
responsiveness don't you think there would be other problem which might
be causing that ?  Your argument about the "desktop feel and
responsiveness" doesn't explain what actual problem did you see.
Also there are lots of distribution kernels which ship with a lower HZ
value anyway, so I don't see why is HZ=1000 such a big requirement for
your desktop use case.

Alok

