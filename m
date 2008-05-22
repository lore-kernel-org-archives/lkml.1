Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYEVEWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYEVEWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYEVEWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:22:37 -0400
Received: from [198.99.130.12] ([198.99.130.12]:55185 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEVEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:22:36 -0400
Date: Thu, 22 May 2008 00:20:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Paul Mackerras <paulus@samba.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522042059.GA17173@c2.user-mode-linux.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick> <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 06:29:43PM -0700, Linus Torvalds wrote:
> > 
> > What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>
> 
> Ahh, I didn't realize people did that.
> 
> I assume (but am too lazy to check) that UML probably does something 
> similar for its arch-specific stuff.

Not quite - there's the include/asm-um/arch link, which points to
../asm-foo and a bunch of #include <asm/arch/foo.h>.  Same idea though.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
