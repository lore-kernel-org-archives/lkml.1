Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYALKIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYALKIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 05:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbYALKIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 05:08:44 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:33871 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbYALKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 05:08:43 -0500
Date: Sat, 12 Jan 2008 11:08:35 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: TimC <tconnors@astro.swin.edu.au>
Cc: Bodo Eggert <7eggert@gmx.de>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080112100835.GA14605@citd.de>
References: <9JpbI-5yi-9@gated-at.bofh.it> <9Jqri-7ym-17@gated-at.bofh.it> <9JqUn-8bF-15@gated-at.bofh.it> <9JvKj-85h-41@gated-at.bofh.it> <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org> <20080111183927.GM2310@csclub.uwaterloo.ca> <alpine.LSU.0.999.0801120236500.9944@be1.lrz> <slrn-0.9.7.4-27208-4606-200801121808-tc@hexane.ssi.swin.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <slrn-0.9.7.4-27208-4606-200801121808-tc@hexane.ssi.swin.edu.au>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2008 18:10, TimC wrote:
> Bodo Eggert <7eggert@gmx.de> said on Sat, 12 Jan 2008 02:41:17 +0100 (CET):
> > On Fri, 11 Jan 2008, Lennart Sorensen wrote:
> > > On Fri, Jan 11, 2008 at 05:22:45PM +0100, Bodo Eggert wrote:
> > 
> > > > What can happen if someone does tune2fs -Lroot /dev/usbstick
> > > > and puts that stick into this system?
> > > 
> > > Don't know.  I use UUIDs rather than LABELs.  Having duplicated labels
> > > just means being careless.  Having duplicate UUIDs should require being
> > > malicous.
> > 
> > That's exactly what you have to assume for your users. Otherwise, you could 
> > remove any security feature from the system.
> 
> If they've got physical access to your machine, you've already lost.

As a last resort there is always the option to encrypt everything.

Of course you loose the LABEL & UUID support with that.

But i circumvented that by a custom udev script and marking the MBR in 
the documented 4 bytes for an ID that is used by said script to create 
an appropriate symlink.

Together with a matching autofs-conf i can still automatically mount all 
my >50 encrypted HDDs i have stacked on my shelf. :-)






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

