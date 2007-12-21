Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXLUXHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXLUXHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXLUXHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:07:30 -0500
Received: from ns.suse.de ([195.135.220.2]:51285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbXLUXHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:07:30 -0500
Date: Fri, 21 Dec 2007 15:06:18 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, bjorn.helgaas@hp.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-ID: <20071221230618.GA16365@suse.de>
References: <20071217210937.103111394@ldl.fc.hp.com> <20071217211337.545932066@ldl.fc.hp.com> <20071218135801.GB17470@elte.hu> <20071221134735.1e0066c9.akpm@linux-foundation.org> <20071221222956.GB24478@suse.de> <20071221224053.GA23289@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221224053.GA23289@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 11:40:53PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > > > arch/x86/kernel/quirks.c |   42 ++++++++++++++++++++++--------------------
> > > > arch/x86/pci/fixup.c     |   22 +++++++++++-----------
> > > 
> > > That made it hard.  Arguably one file is PCI tree and the other is 
> > > x86 tree.
> > 
> > Hm, as traditionally we haven't had such an active x86 maintainer, 
> > I've handled most of the pci quirk type stuff that people have sent to 
> > me in the past :)
> > 
> > But, now that we have more enthusiastic developers, I can change this. 
> > If you want me to cut portions of the patch up, I'll be glad to do so, 
> > just let me know.
> > 
> > It's easy for me when merging, as our tools can handle it just fine, 
> > but Andrew is the one with the big problems, so we should probably 
> > shake it out on our end first...
> > 
> > Ingo, what is easiest for you to do?  As I use quilt, I can very 
> > simply cut a portion of the patch up, or drop it entirely.
> 
> There's one patch right now in x86.git that affects 
> arch/x86/kernel/quirks.c and arch/x86/pci/fixup.c - the one from Bjorn. 
> (find below)

That's the same one I have :)

> Are your quirks (and other arch/x86) patches nicely standalone? If yes 
> then we could pick them up just fine - patch-bomb me or send a tarball 
> or mbox of the patches - whichever is the most convenient for you. (we 
> too use quilt as the main repository)

They are usually mixed up with the other pci patches in my pci tree:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci/

> but if there's some dependency on continuing pci/driver infrastructure 
> you might be working on then it would be better for you to carry them. 
> Or if you'd just like to have Bjorn's patch in one piece. Tell me and 
> i'll drop the changes below from x86.git.
> 
> In any case, both variants would be fine for us - the important thing is 
> to not drop any of the patches on the floor :)

How about you drop this one patch, and I'll keep it, as it goes along
with the other 2 patches in his series, and I'll make sure to check if I
have future pci quirk patches that affect the x86/ directory.

Sound reasonable?

thanks,

greg k-h
