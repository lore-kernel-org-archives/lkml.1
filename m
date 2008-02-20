Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYBTGT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYBTGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbYBTGTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:19:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:4345 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbYBTGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kLXk2ewYDYBUSIqRIM4ytPvctiPBMlDHCzMD3KlRyMQMZi00UZBHSR52y56QpUsnCmjp/oGmyOxPz4omZl/8EPqUj1s3QFqVX3dJihQMbLtQ4K37qtW+kWdwNFOn92VmJKsCj0lhylnXcR5owQ6AJscoNWuz+0IMjcyxi1NOYp0=
Message-ID: <b6a2187b0802192219k76153d8dsd3fa9c80d9e8e1f7@mail.gmail.com>
Date: Wed, 20 Feb 2008 14:19:10 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <200802192032.44715.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0802191653q4dfaa32cl96b9278e97606ef0@mail.gmail.com>
	 <200802191700.12050.jesse.barnes@intel.com>
	 <alpine.LFD.1.00.0802191827190.7833@woody.linux-foundation.org>
	 <200802192032.44715.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 12:32 PM, Jesse Barnes <jesse.barnes@intel.com> wrote:
>
> On Tuesday, February 19, 2008 6:28 pm Linus Torvalds wrote:
> > On Tue, 19 Feb 2008, Jesse Barnes wrote:
> > > I found the same poweroff issue on my T61.  It turned out to be related
> > > to the C state code disabling interrupts when it shouldn't iirc.  Booting
> > > with 'idle=poll' seems to work around the problem.
> > >
> > > The "green screen" problem should be fixed (see the DRM git tree for
> > > details).
> Jeff, can you retest with Linus' tree?  If you're still seeing problems, it
> might help to add some printks to the i915 driver's suspend routine.  Just
> reading the regs really shouldn't cause a hang, but maybe the VGA bits are
> subtly wrong again...

The funny thing is the screen is now normal during suspend, but the
green came back after suspend!

And the suspend still does NOT power off with lastest Linus's tree.

I'll try the "idle=poll" to see if that works and will try some printk as well.

Thanks,
Jeff.
