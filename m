Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYI3CGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYI3CGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYI3CGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:06:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYI3CGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:06:00 -0400
Date: Mon, 29 Sep 2008 19:06:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jiri Kosina" <jkosina@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
Message-ID: <20080929190612.111f16ac@infradead.org>
In-Reply-To: <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	<Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	<alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	<21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 11:59:58 +1000
"Dave Airlie" <airlied@gmail.com> wrote:

> On Tue, Sep 30, 2008 at 11:56 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Tue, 30 Sep 2008, Jiri Kosina wrote:
> >>
> >> Intel is working with us on tracking down and resolving the issue,
> >> but this is not going as well as one would like to see (one
> >> attempt, one card with completely hosed EEPROM contents ... and
> >> restoring the contents is not *that* trivial).
> >
> > What's the magic to trigger it? I've got a laptop with that e1000e
> > chip in it, and am obviously running a recent kernel on it. Do
> > people have a handle on it? Is it actually verified to be
> > kernel-related, and not related to the X server etc?
> 
> If we had the magic we'd have fixed it by now, the current working
> theory is its X server related. This
> hasn't been proven, though my ATI GPU e1000e seems fine so it may have
> some legs.
> 
> If it is X related then its both a kernel + X server issue, the e1000e
> driver opens the barn door, the X server drives the horses through it.
> 
> Of course until someone produces a way to fix the hw after it breaks,
> reproducing this isn't something for the feint hearted. I'm hoping my
> laptop
> comes back today with a brand new motherboard in it.
> 

we have a patch to save/restore now, in final testing stages
(obviously we want to be really careful with this)

Note that so far it seems to mostly hit with "new" distros, so both
new kernel and new X... ;(


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
