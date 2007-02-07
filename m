Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbXBGAiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbXBGAiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbXBGAiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:38:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41708 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbXBGAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:38:07 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	 <1170803515.29759.1032.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
	 <1170804983.29759.1051.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org>
	 <1170806622.29759.1063.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 00:37:59 +0000
Message-Id: <1170808679.29759.1081.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 16:21 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Feb 2007, David Woodhouse wrote:
> > 
> > It isn't that far off, and we could improve it if we wanted to. In
> > _general_ it's quite good already.
> 
> I agree that it's close to hierarchical. But it's literally the exceptions 
> that get you.
> 
> Let me mention (again) USB_STORAGE and ATA.
> 
> They are not "under" SCSI. Making them do that would be insane.

But in the graphical tool that's _good_. Because those are the options
you _wanted_ to see.

You don't want to go digging around under the SCSI menu where all those
boring hostadapters are, but you _do_ get to see the USB and ATA stuff
elsewhere.

But that's only for the graphical tool, which is where I actually
expected the handholding to be required. If you want it in 'oldconfig'
then I think that's weird, but I don't have a better solution than
'select', unfortunately.

> > It would work quite nicely in the graphical tools, although you've
> > thrown me a little by wanting it in the hacker's tool 'oldconfig' too.
> > You obviously care more about turning stuff _on_ with 'make oldconfig'
> > while other people who've spoken up seem to care more, as I do, about
> > turning stuff _off_ that way. If I want my hand held, I'm happy enough
> > to use the graphical tools.
> 
> I tend to just edit the .config file, and run "make oldconfig". And I know 
> I'm not the only one, because I've talked to others who do the same.

That's exactly what I do too.

> And yes, then it's almost always correct to "turn things on as needed to 
> make everything work out right", while turning things off would be 
> actively wrong.

My experience is exactly the opposite; perhaps because I spend so much
of my time working on the Fedora kernel where almost everything starts
off enabled by default, and I only ever want to turn stuff off.

I think 'make oldconfig_noselect' is the way forward. We can both have
what we want.

-- 
dwmw2

