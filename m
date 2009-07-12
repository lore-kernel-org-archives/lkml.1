Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZGLFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZGLFwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 01:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZGLFwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 01:52:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:45862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZGLFwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 01:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mN2dD5Oi8BqdLmKnmh3kB2zMvG+yLqp4IVAdJUjrJI9CxyHJ61nipWAbdAp+19xSeN
         QYj6+RcSsNqRdguAR/hwd4tHe/lFBRFD3nZoX9b0H5h0eNT4FARtVrHVGTz+Ce0qGEVk
         JkrjDg4u5DuuEa2a1B9n1hbnxqQJXTSVOgxf8=
Date: Sun, 12 Jul 2009 09:52:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic - set cpu_has_apic for discrete apic
Message-ID: <20090712055200.GB4782@lenovo>
References: <20090711212929.GG5325@lenovo> <alpine.LFD.2.00.0907120141020.13862@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907120141020.13862@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 12, 2009 at 01:41:54AM +0100]
| On Sun, 12 Jul 2009, Cyrill Gorcunov wrote:
| 
| > In case of discrete apic (due to hardware or firmware reason)
| > cpuid may not retrieve cpu_has_apic bit. So for SMP
| > compiled kernels instead of long check we may set "fake"
| > cpu_has_apic bit and check only the bit in further code
| > flow.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| > 
| > Please review carefully.
| 
|  Sure: how did you test it or plan to do so?
| 
|   Maciej
| 

  Well, I've been using code reading. No real hardware test.
I just don't have such a hardware.

  I've a two pretty old laptops will check today if they
are discrete apic based systems.

  Also I was thinking about spurious software tests --
ie to set discrete apic manually but actually I don't
think it will help.

  And also I hoped that Ingo has a hw farm even with
discrete apic maybe... :)

	-- Cyrill
