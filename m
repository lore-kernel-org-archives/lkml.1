Return-Path: <linux-kernel-owner+w=401wt.eu-S934592AbYBGAgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592AbYBGAgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbYBGADc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:03:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40678 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764956AbYBGADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:03:31 -0500
Date: Wed, 6 Feb 2008 16:00:33 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [stable] The SMP alternatives code breaks exception fixup?
Message-ID: <20080207000033.GB16116@kroah.com>
References: <479504F6.4080005@redhat.com> <p73zluymnx0.fsf@crumb.suse.de> <alpine.LFD.1.00.0801221312200.3199@apollo.tec.linutronix.de> <47964FD5.6020801@redhat.com> <20080206231020.GB12395@kroah.com> <alpine.LFD.1.00.0802061534470.2883@woody.linux-foundation.org> <20080206234309.GA13758@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206234309.GA13758@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 12:43:09AM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > I don't see this in Linus's tree, am I just missing it?  Do you have 
> > > a git commit id?
> > 
> > Isn't this 9d55b9923a1b7ea8193b8875c57ec940dc2ff027 (possibly with 
> > 2532ec6d178abc55681d049097d3dc577eaa266c on top)?
> 
> yeah.
> 
> Greg: note that this is against post-unification asm-x86/futex.h so it 
> wont apply to .24.
> 
> I've backported the fix to .24 - find it below. (untested but obvious)

Thanks for the fix, I'm guessing that this should only go into
.24-stable and nothing prior?

thanks,

greg k-h
