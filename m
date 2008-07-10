Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYGJIdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYGJIdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYGJIdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:33:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37077 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYGJIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:33:30 -0400
Date: Thu, 10 Jul 2008 10:34:23 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -mm 7/8] ACPI hibernation: Utilize hardware signature
Message-ID: <20080710083423.GD5629@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100205.52308.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100205.52308.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: ACPI hibernation: Utilize hardware signature
> 
> ACPI defines a hardware signature.  BIOS calculates the signature
> according to hardware configure and if hardware changes while
> hibernated, the signature will change.  In that case, S4 resume
> should fail.
> 
> Still, there may be systems on which this mechanism does not work
> correctly, so it is better to provide a workaround for them.  For
> this reason, add a new switch to the acpi_sleep= command line
> argument allowing one to disable hardware signature checking.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
