Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0CDTjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:39:40 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:61597 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab0CDTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:39:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nvi3bKE4HAK0DiaY4WzQzrAGzAu0T3C6JnOoQvpVgOMTJaR/PmvSbUI8MsI+04yYnp
         8+LmA/SG3oSKLemvR0TffnCyIIbztjn1j8dQaewZ77B6dx/pBsqMJNVsXlSOdLJaFqrF
         c5h9PPBmaZohnPgifttr3GfnfbSmN52cVLT70=
Message-ID: <4B900AB2.1020603@garzik.org>
Date: Thu, 04 Mar 2010 14:32:02 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain> <20100304190450.GA23807@srcf.ucam.org>
In-Reply-To: <20100304190450.GA23807@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 02:04 PM, Matthew Garrett wrote:
> "Please note that these drivers are under heavy development, may or may
> not work, and may contain userspace interfaces that most likely will be
> changed in the near future."

Shipping it as the default Fedora driver for NVIDIA hardware makes that 
text largely irrelevant.

Jesse said
> Dave and the nouveau guys include the driver in Fedora to get
> much needed test coverage, and make sure the latest bits in rawhide
> work together.

but when it is the default driver, it is the default _production_ driver 
for Fedora users, in an official, stable Fedora release.

And the alternative?  You said
> F-12 continues to ship the -nv driver, which will work fine with any
> kernel version as long as nouveau is disabled.

FAIL.  I actually tried that.  Have you?  Do you think it is remotely 
easy for a technically component, non-Xorg-hacker type to accomplish?

I attempted to use the non-default 'nv' driver just before nouveau was 
merged into upstream/staging, because I wanted a development kernel that 
actually worked on my Fedora-based devel boxes.  It was a complete 
exercise in frustration, requiring at least one bugzilla bug report, and 
ultimately resulted in failure.

I gave up and waiting for Linus to merge nouveau, which instantly made 
my life a lot easier :)

Kernel hacking on Fedora, my own dogfood, has become increasingly 
cumbersome because of all these graphics issues.  Sometimes it's just 
easier to test a modern kernel on an ancient distro, sadly.

	Jeff



