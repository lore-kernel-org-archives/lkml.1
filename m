Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbXC0FvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbXC0FvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934043AbXC0FvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:51:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33092 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041AbXC0FvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:51:09 -0400
Message-ID: <4608B0CA.1040005@garzik.org>
Date: Tue, 27 Mar 2007 01:51:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: ATA ACPI (was Re: Linux 2.6.21-rc5)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> There's various fixes here, ranging from some architecture updates (ia64, 
> ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
> 
> And random one-liners.
> 
> But probably more important, and likely much more visible to most people 
> is the fixes for the fallout from the hrtimers and no-HZ changes, and some 
> of the ACPI regressions.
> 
> Those timer changes ended up much more painful than anybody wished for, 
> but big thanks to Thomas Gleixner for being on it like a weasel on a dead 
> rat, and the regression list has kept shrinking.
> 
> So if you have reported a regression in the 2.6.21-rc series, please check 
> 2.6.21-rc5, and update your report as appropriate (whether fixed or "still 
> problems with xyzzy").
> 
> 		Linus


[just got back from vacation, or would have sent this earlier]

FWIW, I'm still leaning towards disabling libata ACPI support by default 
for 2.6.21.

Upstream has Alan's fix for the worst PATA problems, but for different 
reasons, I think PATA ACPI and SATA ACPI support in libata does not feel 
quite ready for prime time in 2.6.21.

Scream now, or hold your peace until 2.6.22... :)

	Jeff


