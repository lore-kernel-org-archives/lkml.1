Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXEXROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXEXROh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbXEXROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:14:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXEXROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:14:12 -0400
Date: Thu, 24 May 2007 10:12:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?iso-8859-15?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Christoph Lameter wrote:
>
> On Thu, 24 May 2007, Michal Piotrowski wrote:
> 
> > Memory management
> > 
> > Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
> > Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
> > Status     : Unknown
> 
> 
> Looks like this is in DRM code:
> 
> BUG: at include/linux/slub_def.h:88 kmalloc_index()

I'm going to change that "BUG:" to "WARNING:". 

I know some people disagreed with it (ie Ingo), but I think that's total 
and utter bullshit.

It's a warning. Right now that "BUG:" message makes people all scared 
about something that is not fatal at all, just a note that something 
hasn't been converted, but is expected to work absolutely fine.

Calling it a bug is idiotic.

			Linus
