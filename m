Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbXCSUpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbXCSUpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXCSUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:45:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53635 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752316AbXCSUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:45:40 -0400
Date: Mon, 19 Mar 2007 21:45:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM fault in VT when resuming
Message-ID: <20070319204531.GA3159@elf.ucw.cz>
References: <45F709F2.80504@canonical.com> <20070313212457.GD12370@elf.ucw.cz> <45F752EF.6030701@canonical.com> <20070319150753.GC1915@elf.ucw.cz> <45FEB71B.90406@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FEB71B.90406@canonical.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> This crash behaves like the video memory space has become unmapped. Is
> >> that possible?
> > 
> > That seems improbable. It is physical ram, we do not unmap that..
> 
> The machine _has_ just come out of BIOS ACPI space. Perhaps PCI
> resources for video are hosed. All I can tell for sure is that this
> one

Yes, this is possible, AFAICT. I'm just saying that it is unlikely to
be unmapped at pagetable level.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
