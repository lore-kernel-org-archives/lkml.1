Return-Path: <linux-kernel-owner+w=401wt.eu-S1764580AbYBZVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764580AbYBZVYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYBZVYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:24:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbYBZVYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:24:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p - resume hang
Date: Tue, 26 Feb 2008 22:22:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Jesse B, arnes"@localhost.corp.fedex.com, jesse.barnes@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jeff Garzik <jeff@garzik.org>
References: <Pine.LNX.4.64.0802261210080.3332@boston.corp.fedex.com>
In-Reply-To: <Pine.LNX.4.64.0802261210080.3332@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262222.48428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 of February 2008, Jeff Chua wrote:
> 
> On Tue, Feb 26, 2008 at 4:45 AM, Michael S. Tsirkin 
> <m.s.tsirkin@gmail.com> wrote:
> > On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton 
> <akpm@linux-foundation.org> wrote:
> > > On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" 
> <m.s.tsirkin@gmail.com> wrote:
> >  >  You mean suspend-to-ram works correctly on your t61p?
> >  >  Mine suspends, then five seconds later magically resumes itself and 
> the
> >  >  screen is all black.
> >  Sorry, have not noticed what you were asking about.
> >  Yes, rc2 seems to suspend/resume fine.
> >  And after reverting
> >      revert commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
> 
> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
> Author: Pavel Machek <pavel@ucw.cz>
> Date:   Thu Feb 21 13:56:55 2008 +0100
> 
>      power_state: get rid of write-only variable in SATA
> 
>      power_state is scheduled for removal, and libata uses it in write-only
>      mode. Remove it.
> 
>      Signed-off-by: Pavel Machek <pavel@suse.cz>
>      Signed-off-by: Jeff Garzik <jeff@garzik.org>

That's already been reverted from the mainline.

Thanks,
Rafael
