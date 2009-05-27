Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZE0TOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZE0TOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbZE0TNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:13:55 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:48352 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbZE0TNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p9fKAfBHkVWC9VJNqyjFGlWUOI3E7tlKDNKhbb37b81jjlpV9QLi/wgq3qz32dNeA4
         uo2Nx+GG2pMLTdkiDcHK01j06PEKGJ1j7S7pPfQM2Ta7DKF+oZnBjFq1iNuZ1TUTaoEH
         xrobG8jlqxMpX8dvDKSC6Tl5WEhmEyFOQFekI=
MIME-Version: 1.0
In-Reply-To: <4A1D8FBA.6040802@freescale.com>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de>
	 <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
Date: Wed, 27 May 2009 15:13:55 -0400
Message-ID: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Jon Smirl <jonsmirl@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
> I'm not talking about platform specific code, I'm talking about code to
> retrieve information about a device from the device tree.  There would not
> be separate instances of this for "platforms X, Y and Z", just one
> of_platform binding in each driver.  It's no different than having a
> platform bus binding, except in the data structures used.
>
> But to restate, having external glue to create platform devices from the
> device tree is fine if that's what you want to do.  We used to do that, but
> it was a pain compared to keeping everything in one place.  Your experience
> may differ.

Could 'struct platform_device' and 'struct of_platform_device" be
unified into a single structure? It's personal preference whether the
internal representation of the hardware is done via a device tree or
snippets of platform code, but do we need to have to different device
types?

-- 
Jon Smirl
jonsmirl@gmail.com
