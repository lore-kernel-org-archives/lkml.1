Return-Path: <linux-kernel-owner+w=401wt.eu-S1763593AbXGNAps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763593AbXGNAps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbXGNApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:45:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:59661 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbXGNApj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=VE8ztKq8tqH/D12/+I9B2pKxo+jU42dT8OvuU3IxdFhT5Ov1MVbPKjG6k473VFJ5sPOdLtsbyHouOKZWWkM5AoJQod7sR0FnxfMvUf/GM63y4QsBRNYPuWul32oKYiU27zp2EV5w8eASLGtYHBYVLWpfax5/D61O8EffXC4W5iQ=
Date: Fri, 13 Jul 2007 20:45:17 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>, david@lang.hm,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070714004517.GA18336@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Joseph Fannin <jfannin@gmail.com>, david@lang.hm,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm> <20070713054244.GA20082@nineveh.local> <200707131130.51279.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707131130.51279.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 11:30:50AM +0200, Rafael J. Wysocki wrote:
> On Friday, 13 July 2007 07:42, Joseph Fannin wrote:
> > On Thu, Jul 12, 2007 at 08:06:43PM -0700, david@lang.hm wrote:
> > > On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> >
> > > > Plus we need to figure out how to avoid corrupting filesystems and
> > > > swap in use by the "old" kernel and its processes (hint: a separate
> > > > "hibernation partition" is a no-go).
> > >
> > > I thought the existing hibernation wrote to the swap partition as it's
> > > dedicated space?
> > >
> > > I didn't know that anyone was suggesting writing the hibernation image to
> > > a filesystem that the kernel was activly accessing.
> >
> > I'm suggesting a dedicated, preallocated hibernation *file*, right
> > now.  There's no way around it, if hibernation is to be reliable --
> > otherwise hibernation can fail if the system has used enough of its
> > swap space, so that there isn't enough room to write the hibernate
> > image.
> >
> > Even if it's desirable to allow hibernation to fail if the system is
> > too deep into swap, it's a moot point.
>
> If you're afraid of that, use a dedicated swap file.

    I don't understand what you mean.  A dedicated swap file for what?

--
Joseph Fannin
jfannin@gmail.com

