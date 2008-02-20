Return-Path: <linux-kernel-owner+w=401wt.eu-S1761196AbYBTEdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbYBTEdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYBTEcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:32:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:23205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYBTEcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:32:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,379,1199692800"; 
   d="scan'208";a="342633280"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Tue, 19 Feb 2008 20:32:44 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>
References: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com> <200802191700.12050.jesse.barnes@intel.com> <alpine.LFD.1.00.0802191827190.7833@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802191827190.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192032.44715.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 19, 2008 6:28 pm Linus Torvalds wrote:
> On Tue, 19 Feb 2008, Jesse Barnes wrote:
> > I found the same poweroff issue on my T61.  It turned out to be related
> > to the C state code disabling interrupts when it shouldn't iirc.  Booting
> > with 'idle=poll' seems to work around the problem.
> >
> > The "green screen" problem should be fixed (see the DRM git tree for
> > details).
>
> ..and the latter is hopefully now merged in my tree too (at least some of
> the drm updates are).

Cool, thanks.

Jeff, can you retest with Linus' tree?  If you're still seeing problems, it 
might help to add some printks to the i915 driver's suspend routine.  Just 
reading the regs really shouldn't cause a hang, but maybe the VGA bits are 
subtly wrong again...

Thanks,
Jesse
