Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbYBTC3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbYBTC3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYBTC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:29:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbYBTC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:29:22 -0500
Date: Tue, 19 Feb 2008 18:28:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802191700.12050.jesse.barnes@intel.com>
Message-ID: <alpine.LFD.1.00.0802191827190.7833@woody.linux-foundation.org>
References: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com> <200802191700.12050.jesse.barnes@intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Feb 2008, Jesse Barnes wrote:
>
> I found the same poweroff issue on my T61.  It turned out to be related to the 
> C state code disabling interrupts when it shouldn't iirc.  Booting 
> with 'idle=poll' seems to work around the problem.
> 
> The "green screen" problem should be fixed (see the DRM git tree for details).

..and the latter is hopefully now merged in my tree too (at least some of 
the drm updates are).

		Linus
