Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZD0Spu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZD0Spu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZD0Spj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:45:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52087 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZD0Spi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:45:38 -0400
Date: Mon, 27 Apr 2009 19:44:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/8] arm: Use __INIT macro instead of .text.init.
Message-ID: <20090427184440.GC30189@flint.arm.linux.org.uk>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <20090427184313.GC12056@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427184313.GC12056@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 08:43:13PM +0200, Sam Ravnborg wrote:
> On Mon, Apr 27, 2009 at 02:02:22PM -0400, Tim Abbott wrote:
> > arm is placing some code in the .text.init section, but it does not
> > reference that section in its linker scripts.
> > 
> > This change moves this code from the .text.init section to the
> > .init.text section, which is presumably where it belongs.
> 
> It looks obviously correct.
> But I tried and failed to follow the chain of usage.

Yup, I did something similar with the other files some year ago, but
these new files got missed.

> So we need an ack from Russell on this one.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
