Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYI3WIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYI3WIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYI3WIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:08:07 -0400
Received: from www.tglx.de ([62.245.132.106]:35197 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYI3WIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:08:06 -0400
Date: Wed, 1 Oct 2008 00:07:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 2.6.27-rc8
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F52064B1CE4@orsmsx418.amr.corp.intel.com>
Message-ID: <alpine.LFD.1.10.0810010006470.5549@apollo.tec.linutronix.de>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
 <36D9DB17C6DE9E40B059440DB8D95F52064B1CE4@orsmsx418.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Brandeburg, Jesse wrote:
> Linus Torvalds wrote:
> > What's the magic to trigger it? I've got a laptop with that e1000e
> > chip in it, and am obviously running a recent kernel on it. Do people
> > have a handle on it? Is it actually verified to be kernel-related,
> > and not related to the X server etc?
> 
> my current status mail was posted earlier today to lkml from this
> address, since then we've had a local reproduction and are going for
> number two.  The reproduction seems racy, i.e. it doesn't happen every
> time, so we put it in a loop doing detect, check eeprom, detect, etc,
> and we'll see if it fails.
> 
> Reproduction seems to consistently be around X probing time, no firm
> leads yet.  As for Intel we have keithp and jbarnes as well as arjan,
> auke, myself and a few others involved.
> 
> We have some patches to lock the nvm down, we'll be posting those
> tonight and tomorrow, I also have some debug logic (and fixes) to help
> prove that we don't think it's a race in e1000e.

Can we get the simple debug patches including the fixes which resulted
from them pushed upstream ASAP ?

Thanks,

	tglx
