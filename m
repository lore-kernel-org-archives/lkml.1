Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbXFUVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbXFUVOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbXFUVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:14:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:42339 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbXFUVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:14:27 -0400
Date: Thu, 21 Jun 2007 23:14:19 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Subject: Re: [Suspend-devel] [PATCH, 3rd try] make disable_console_suspend runtime configurable
Message-ID: <20070621211419.GD31090@suse.de>
References: <20070613200303.GB11437@suse.de> <200706141414.22152.rjw@sisk.pl> <200706141559.54242.fseidel@suse.de> <200706150020.29189.rjw@sisk.pl> <20070617213530.GE1803@elf.ucw.cz> <20070617214940.GA1951@elf.ucw.cz> <20070618052747.GA15173@suse.de> <20070621132008.GE18392@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621132008.GE18392@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha5, Kernel 2.6.22-rc4-git6-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 03:20:08PM +0200, Pavel Machek wrote:
> Hi!
 
> > No, i don't agree at all.
> > 
> > In this case, "no config needed" == "not possible to debug suspend
> > problems".
> 
> No, sorry.
> 
> My proposed solution is "figure out which console drivers can survive
> being on while machines go down, and keep them on".
> 
> So, "no config needed" == "kernel always does the right thing, keeping
> console during suspend when possible" == "possible to debug suspend
> problems without having to change CONFIG_ or /sys/*".

Ok. Deal. Once you fixed all the console drivers, i'll gladly send a patch
that reverts the patch we are discussing now.

Note that this patch actually helps fixing those drivers, since you can
test much easier if a given driver survives suspend ;-)
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
