Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZGTOKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZGTOKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZGTOKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:10:05 -0400
Received: from centrinvest.ru ([94.25.115.130]:54582 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZGTOKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:10:04 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 20 Jul 2009 18:09:56 +0400
To: Thomas Hellstr?m <thomas@shipmail.org>
Cc: DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
 Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720140956.GB11781@centrinvest.ru>
Mail-Followup-To: Thomas Hellstr?m <thomas@shipmail.org>,
	DRI <dri-devel@lists.sourceforge.net>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4A647358.1040009@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A647358.1040009@shipmail.org>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 201, 07 20, 2009 at 03:38:32PM +0200, Thomas Hellstr?m wrote:
> Hi!
> 
> It appears that GPL'd DRM drivers for closed-source user-space
> clients are becoming more common, and the situation appears to be
> causing a lot of unnecessary work from people wanting their drivers
> in the mainstream kernel. Arguments against pushing upstream
> include.
> 
>    * Security.
>    * User space interface validation and maintainability.
>    * Politics

Why should linux kernel developers care about these drivers at all ?

 * If such driver is accepted it immediately puts compatibility burden on drm
developers without any gain for them.

 * Users are still on mercy of binary blob supplier. Will this blob run on arm ?
Or powerpc ? Or even x86_64 ? Will it be compatible with XOrg X.Y ?
Nobody knows that and there is no gain for users too.


> Security:
> I think from a security point of view, open docs and a thorough
> documented security analysis by the driver writer should be
> sufficient. This should include:
> 
>   1. In what ways can the GPU access random system pages and how is
>      user-space prevented from doing that in the driver?
>   2. In what ways can the GPU transfer random user data into its own
>      privileged command stream and, if relevant, how is that prevented
>      in the driver?
>   3. Is the driver capable of maintaining video memory ownership and
>      protecition?
>      (Currently not a requirement)
>   4. How is user-space prevented from causing the kernel driver to do
>      unlimited allocations of kernel resources, like buffer objects or
>      references to them.
> 
> I really don't think an open-source user-space client can add much
> more to this. It can perhaps be used to detect obvious big security
> flaws but that should be apparent also from the open docs and the
> security analysis.
> 
> User-space interface:
> Historically driver-specific interfaces have really been up to the
> driver writer and when posted for review they receive very little
> comments unless there are things like 64/32 bit incompatibilities
> etc, but as mentioned on the list, small programs that demonstrate
> the use of all interface functions would be desirable, and very
> helpful if someone decides to do write an open-source driver.
> 
> Politics:
> It's true that sometimes some people don't like the code or what it
> does. But when this is the underlying cause of NAK-ing a driver I
> think it's very important that this is clearly stated, instead of
> inventing various random reasons that can easily be argued against.
> How should the driver writer otherwise get it right? Man-years might
> be spent fixing up drivers that will never get upstream anyway.
> 
> I think it would help a lot of there was a documented set of driver
> features that were required and sufficient for a DRM driver to go
> upstream. It could look something like
> 
>    * Kernel coding style obeyed. Passing checkpatch.
>    * short description of underlying driver architecture (GEM / TTM /
>      Traditional) and future plans
>    * Security analysis according to the above.
>    * Open user-space source exercising all functions of the driver or
>      fully open docs.
>    * User-space interface description and relation to future plans.
> 
> 
> Thanks,
> /Thomas
> 
> 
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
