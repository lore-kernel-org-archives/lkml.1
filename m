Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZFFIP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZFFIP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZFFIPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:15:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56827 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZFFIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:15:10 -0400
Date: Sat, 6 Jun 2009 09:14:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 17/39] kbuild: fix header export when __ASSEMBLY__ is
	used
Message-ID: <20090606081453.GA30463@flint.arm.linux.org.uk>
References: <20090605233720.GA13588@uranus.ravnborg.org> <1244245377-17441-17-git-send-email-sam@ravnborg.org> <200906060041.07600.arnd@arndb.de> <20090606060552.GA22347@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606060552.GA22347@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 08:05:52AM +0200, Sam Ravnborg wrote:
> On Sat, Jun 06, 2009 at 12:41:07AM +0000, Arnd Bergmann wrote:
> > On Friday 05 June 2009 11:42:35 pm Sam Ravnborg wrote:
> > > Because it does not know __ASSEMBLY__ it does not
> > > detect that htis is not for userspace.
> > > This caused too much code to be exported, and headers_check barfed
> > > over this code.
> > > 
> > > For arm this fixes following "make headers_check" warning:
> > > /usr/include/asm/hwcap.h:29: extern's make no sense in userspace
> > 
> > Are you sure that this is safe for all user space? If a user application
> > for instance includes asm/signal.h or asm/types.h from assembly (for
> > whatever reason), it now breaks.
> 
> I had not thought about this implication.
> I will drop the patch as this most likely
> will break some userspace.

So now go back and re-read my original email.  I was not suggesting to
undefine __ASSEMBLY__ - I was more detailed in my _question_ which I
was making, and there were _two_ possibilities.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
