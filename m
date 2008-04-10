Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYDJS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYDJS61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYDJS6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:58:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34785 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbYDJS55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:57:57 -0400
Date: Thu, 10 Apr 2008 20:58:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080410185824.GB21893@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local> <20080207130222.GA8587@flint.arm.linux.org.uk> <20080207141236.00940d09@dilbert.local> <20080211092547.09bca061@dilbert.local> <20080410122127.GA8096@digi.com> <20080410122706.GG26575@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410122706.GG26575@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi rmk

On Thu, Apr 10, 2008 at 01:27:06PM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 10, 2008 at 02:21:27PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > Hans-Jürgen Koch wrote:
> > > Am Thu, 7 Feb 2008 14:12:36 +0100
> > > schrieb Hans-Jürgen Koch <hjk@linutronix.de>:
> > > 
> > > AFAICT, this patch was neither rejected nor applied. It generated a
> > > long thread about changing the whole ARM Kconfig system. I feel not
> > > qualified to do that, but I still want UIO available on ARM ;-)
> > > What can I do to help?
> > Anything new here?
> > 
> > In my eyes this can be sent to the patch system.
> 
> I don't remember anything about this...

When this topic was last discussed we looked into what prevented
ARM from using the generic drivers/Kconfig.
The conclusion was that only IDE and MTD did so.
The IDE issue was quickly fixed in upstream by introducing HAVE_IDE
and the MTD issue were concluded to be a non-issue.

So there should not be any problems left to my best knowledge to
use the generic drivers/Kconfig for arm.

	Sam
