Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbYEEPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbYEEPJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYEEPIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:08:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbYEEPIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:08:54 -0400
Date: Mon, 5 May 2008 08:08:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Jan Engelhardt <jengelh@medozas.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <alpine.LFD.1.10.0805050801120.32269@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805050805460.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <alpine.LNX.1.10.0805050835450.11757@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0805050735150.32269@woody.linux-foundation.org>
 <481F1EB3.3040906@garzik.org> <alpine.LFD.1.10.0805050801120.32269@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Linus Torvalds wrote:
> 
> Right. Which is why I build the stuff into my kernel that is required, and 
> then initrd can do whatever it damn well pleases.

Btw, I realize that a distro *can* make an initrd that only works with 
their own kernel. I personally suspect I'll just switch distros if that 
happens - I'm already irritated enough with startup scripts etc that 
complain about "/proc/modules: No such file or directory" for stuff that 
is already compiled in because they want to check if it's loaded.

But quite frankly, the distro really shouldn't need to make their startup 
scripts (whether on initrd or just the regular /etc/rc.d/ ones) so 
fragile. And quite frankly, I don't understand why people seem to use a 
kernel *BUG* as an excuse to say that I shouldn't do what I have always 
done - replace just the kernel.

				Linus
