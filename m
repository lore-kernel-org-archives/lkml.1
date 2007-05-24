Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXEXTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXEXTWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXEXTWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:22:35 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbXEXTWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:22:32 -0400
Date: Thu, 24 May 2007 12:21:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <20070524114902.e802f327.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0705241220070.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
 <20070524114902.e802f327.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Andrew Morton wrote:

> On Thu, 24 May 2007 10:12:14 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > BUG: at include/linux/slub_def.h:88 kmalloc_index()
> > 
> > I'm going to change that "BUG:" to "WARNING:". 
> 
> I think we should remove these kmalloc(0, ...) warnings prior to
> the 2.6.22 release, put them back afterwards.

Orthogonal issue, but yes, I agree. I'll do that too, but let's keep it 
for now.

> I'm not sure how we could do this, apart from patching and unpatching a
> config file each time.

Doing it in the Makefile would make more sense, since I have to edit that 
file anyway to change -rc5 to -rc6.

		Linus
