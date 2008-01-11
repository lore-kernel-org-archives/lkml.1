Return-Path: <linux-kernel-owner+w=401wt.eu-S1762449AbYAKTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449AbYAKTN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758791AbYAKTNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:13:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:53532 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbYAKTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:13:51 -0500
Date: Fri, 11 Jan 2008 11:14:05 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080111191405.GA25702@suse.de>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111110931.323ee056@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111110931.323ee056@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:09:31AM -0800, Arjan van de Ven wrote:
> On Fri, 11 Jan 2008 11:02:29 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Dec 25, 2007 at 03:26:05AM -0800, Arjan van de Ven wrote:
> > > 
> > > This patch also adds a sysfs property for each device into which
> > > root can write a '1' to enable extended configuration space. The
> > > kernel will print a notice into dmesg when this happens (including
> > > the name of the app) so that if the system crashes as a result of
> > > this action, the user can know what action/tool caused it.
> > 
> > Can you send me a follow-on patch that documents this in
> > Documentation/ABI please.
> > 
> 
> once it's stable enough, say after 1 kernel release, sure

That's what the Documentation/ABI/testing section is for.  If you add
something new, it needs to be documented now, otherwise it will be
forgotten.

thanks,

greg k-h
