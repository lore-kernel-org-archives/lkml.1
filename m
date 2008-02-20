Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbYBTXlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbYBTXlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYBTXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:41:35 -0500
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:51286 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754899AbYBTXle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:41:34 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 18:41:34 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 15:34:35 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201432.13393.jesse.barnes@intel.com> <200802201503.44656.jbarnes@virtuousgeek.org>
In-Reply-To: <200802201503.44656.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201534.36174.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 3:03 pm Jesse Barnes wrote:
> On Wednesday, February 20, 2008 2:32 pm Jesse Barnes wrote:
> > On Wednesday, February 20, 2008 11:10 am Jeff Chua wrote:
> > > On Feb 21, 2008 2:53 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > > > > So, next I'll try "shutdown" to see if it work. I was using
> > > > > "platform".
> > > >
> > > > Ok, that would be good to try.
> > >
> > > "shutdown" does power down properly. But still green on resume.
> > >
> > > > Looks like the AR registers are hosed, which is what I thought I
> > > > fixed... Can you attach your i915_drv.c file just so I can sanity
> > > > check it?
> > >
> > > Attached.
> >
> > Jeff, for the hang on suspend problem, I know suspect something else in
> > 2.6.25-rc2 caused that.
>
> Looks like 2.6.25-rc1 also had broken suspend (my test was broken).  IIRC,
> Dave and I had it working at LCA using the out of tree DRM modules on
> 2.6.23.14 or 15...  Maybe you could give that a try?

And just to confirm that, I just tested the current DRM modules against a 
2.6.23.15 kernel.  It suspends to disk correctly (w/o a hang) and doesn't 
give me a green screen, so something in 2.6.25 must be causing that (even 
2.6.25-rc1 seems to have the problem).

Also, this patch against 2.6.25-rc1 seemed to prevent the 'green screen' 
problem.  2.6.25-rc2 already has part of it...

Anyway, let me know how your testing goes.

Thanks,
Jesse
