Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbXF2SFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbXF2SFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbXF2SFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:05:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbXF2SFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:05:33 -0400
Date: Fri, 29 Jun 2007 20:03:44 +0200
From: Stefan Seyfried <seife@suse.de>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Rafael Wysocki <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Message-ID: <20070629180344.GA17907@suse.de>
References: <200706192118.23706.nigel@nigel.suspend2.net> <20070628142532.GC5339@ucw.cz> <200706290827.13024.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706290827.13024.nigel@nigel.suspend2.net>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git6-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 08:27:12AM +1000, Nigel Cunningham wrote:
> > Can we rename/reuse existing flag variable?
> 
> Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> 
> Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> variable (I assume this is what you're thinking of), we only create cause for 
> confusion. A variable should for debugging or for controlling quirks, not for 
> both at the same time.

I agree. And video_flags is something totally different :-)
I just used that one in my ad-hoc hack (which actually was only to illustrate
the idea) because a) it was enough to show the intent and b) i did not know
how to do it better ;-)
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
