Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYAMRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYAMRET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYAMREE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 12:04:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYAMREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 12:04:02 -0500
Date: Sun, 13 Jan 2008 09:03:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tcamuso@redhat.com
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080113090311.0a9a1db5@laptopd505.fenrus.org>
In-Reply-To: <478A075F.7010503@redhat.com>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<20080112214911.GA20102@jurassic.park.msu.ru>
	<20080112150120.05f93768@laptopd505.fenrus.org>
	<47895767.3090503@redhat.com>
	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>
	<47896B3B.2000108@redhat.com>
	<20080112204248.29abb1dd@laptopd505.fenrus.org>
	<478A075F.7010503@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 07:43:11 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> Arjan van de Ven wrote:
> > On Sat, 12 Jan 2008 20:36:59 -0500
> > Tony Camuso <tcamuso@redhat.com> wrote:
> > 
> >
> > Just about NOBODY has devices that need the extended config space.
> > At all.
> 
> The PCI express spec requires the platform to provide access to this
> space for express-compliance.

PLATFORM not OS :)
Windows isn't using it in the server space, and only in the client space it recently started
considering it.

> More devices will be using this space
> as express becomes the dominant IO bus technology.

sure in like 2009 maybe.


> Which is why Loic's proposal and Ivan's implementation of it is so
> elegant. It solves all these problems in one sweep, and eliminates
> the code rendered cruft by Ivan's patch. A two-fer, by my reckoning.
> 
> >> In other words, for x86, I don't think we need to worry about Port
> >> IO config access ever going away at all.
> > 
> > You're wrong there. Sad to say, but you're wrong there.
> > 
> 
> The PCI spec provides for conf1 as an architected solution. It's not
> going away, and especially not in x86 land where Port IO is built-in
> to the CPU.

again sadly you're wrong. 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
