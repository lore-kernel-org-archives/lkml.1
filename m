Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXCLXkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXCLXkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXCLXkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:40:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbXCLXkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:40:05 -0400
Date: Mon, 12 Mar 2007 19:39:46 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070312233946.GE21835@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
	ak@suse.de, linux-kernel@vger.kernel.org
References: <20070306181430.GB3151@strauss.suse.de> <20070306182134.GB9491@redhat.com> <20070312104352.GA4313@ucw.cz> <20070312205513.GC21835@redhat.com> <20070312231220.GC9749@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312231220.GC9749@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:12:20AM +0100, Pavel Machek wrote:

 > > 65535 characters? Are you for real?
 > > Stop and think about just how big that is. If you have to create
 > > a boot command line that long, you have serious, serious issues.
 > 
 > Well, it is about the same size as my .config...

So? That has *nothing* to do with the boot command line

 > I agree we are unlikely to hit it any time soon... I could imagine
 > some (ab)uses, like fixed_acpi_bios=<lots of hex digits>, but those
 > are ugly.

That's beyond ugly, and rapidly heading towards 'loony'.

 > I could also imagine some uses where entire embedded machine
 > is described at kernel commandline.

There are far better ways to get configuration into the kernel
than the boot command line.

Anyways, I'm tired of arguing for the sake of arguing.
I really could care less.

	Dave

-- 
http://www.codemonkey.org.uk
