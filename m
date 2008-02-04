Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYBDTqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYBDTqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYBDTqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:46:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42819 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbYBDTqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:46:22 -0500
Date: Mon, 4 Feb 2008 20:46:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] kbuild: Fix instrumentation removal breakage on avr32
Message-ID: <20080204194626.GA16664@uranus.ravnborg.org>
References: <20080203211042.GF2648@uranus.ravnborg.org> <20080204124448.3633e937@dhcp-252-066.norway.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204124448.3633e937@dhcp-252-066.norway.atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 12:44:48PM +0100, Haavard Skinnemoen wrote:
> On Sun, 3 Feb 2008 22:10:42 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Mathieu Desnoyers (5):
> >       Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
> 
> AVR32 still includes Kconfig.instrumentation, so it won't build after
> this...
> 
> I did point this out when the patch was submitted, I sent the avr32
> pull request early as promised (more than a week ago), but it still
> broke. Please apply the fix below. This fixes 2.6.24-mm1 too.

Sorry for not catching this.
I just blow away my git tree at kernel.org to avoid getting it
merged with the bug but Linus was too quick for me so he already
merged kbuild.git and applied this patch afterwards.

	Sam
