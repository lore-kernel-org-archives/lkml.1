Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZKPRFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZKPRFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZKPRFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:05:46 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54083 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbZKPRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPNrJOFECTJ8AVuXmrXCe33WK/PPmwqFBP6mwPBaOhQLICVkvQozalsNGu8oYWEOcZ
         EBbncjzoSivdeH9mXdnHpRacrX39l9UuZtrpdn/0D8tkfy4Jaa/UM5yapMHychc10ZvC
         +PyKRjCwMTJ1+7XDeSDAIvIXuag808yOVF4IU=
Date: Mon, 16 Nov 2009 09:05:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Soeren Sonnenburg <sonne@debian.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, olh@suse.de,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mouse button 1 emulation for mac_hid
Message-ID: <20091116170543.GB24026@core.coreip.homeip.net>
References: <1257762531.7245.23.camel@no> <20091114054246.GF4463@core.coreip.homeip.net> <alpine.LRH.2.00.0911161358240.31913@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0911161358240.31913@twin.jikos.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 01:59:37PM +0100, Jiri Kosina wrote:
> On Fri, 13 Nov 2009, Dmitry Torokhov wrote:
> 
> > > I am not sure what the future of mac_hid is (the source says will be
> > > removed, but since 9 years). In case it stays in kernel the attached
> > > patch adds support for mouse button 1 emulation. If this driver stays in
> > > the kernel I would also suggest to rename it - it is not mac specific (I
> > > am using this on a netbook).
> > > 
> > > Rationale? Broken touchpads, within linux unsupported (multi-)touchpads
> > > where click and hold + moving the mouse does not work (yet?).
> > 
> > I would rather fix the touchpads so they work properly than pile more
> > quirks in kernel.
> 
> Hi Dmitry,
> 
> in exactly what way are you planning to "fix the touchpads"?
> 

Hi Jiri,

It would be helpful to know which ones are currently. Obviously we can't
help with physically broken ones but I don't believe it is kernel's task
to deal with physically broken hardware. The ones that are not
physically broken - PS/2 should have fairly decent hardware emulation
mode (at least all I tried supported tap and trag while working as
regular PS/2 mouse) - so that can be used while we figuring out native
protocol. USB - appletouch, bcm - are there any issues at the moment?

-- 
Dmitry
