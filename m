Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbXJQGci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbXJQGci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXJQGca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:32:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:64020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbXJQGc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:32:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,287,1188802800"; 
   d="scan'208";a="348435206"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Date: Tue, 16 Oct 2007 23:32:10 -0700
User-Agent: KMail/1.9.7
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <200710161940.05785.jesse.barnes@intel.com> <20071017062515.GA8588@khazad-dum.debian.net>
In-Reply-To: <20071017062515.GA8588@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710162332.11318.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 16, 2007 11:25 pm Henrique de Moraes Holschuh wrote:
> On Tue, 16 Oct 2007, Jesse Barnes wrote:
> > > Last time the issue was brought up (and I do believe it was
> > > because of thinkpad-acpi :-) ), he made it clear that any events
> > > you are to act upon are fine in input, but events that are just
> > > notifications (i.e. the firmware already did the action) are not.
> >
> > Ah yeah, I agree with that.  Regular events should be uevents or
> > something, not input events.  Actual keyboard keys though (whether
> > they generate firmware event messages or actual scancodes) should
> > probably go through the input layer.  I thought that's what
> > Jeremy's patch was doing, maybe I didn't look closely enough.
>
> The patch adds keycodes for "keys" that are acually notifications on
> many thinkpads.  And that is the problem, please refer to the rest of
> the thread for more details...

Yeah, just read through it.  It really doesn't seem like it matters that 
much whether "keypress+notify" events are delivered via the input layer 
or via some sort of uevent.

However, since we already have userspace code in place handling the 
input layer case, why not just go with it?  It's fairly straightforward 
and already works in some distros.

Jesse
