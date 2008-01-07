Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYAGBzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYAGBzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYAGBza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:55:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYAGBz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:55:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yi.y.yang@intel.com
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to  "unsupported" if wakeup feature isn't supported by a device
Date: Mon, 7 Jan 2008 02:57:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Brownell <david-b@pacbell.net>, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com> <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <1199669879.19185.20.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1199669879.19185.20.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070257.58884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Yi Yang wrote:
> On Fri, 2008-01-04 at 08:09 -0800, David Brownell wrote:
> > > > This patch changes empty output to "unsupported" in order that a user knows
> > > > wakeup feature isn't supported by this device when he/she
> > > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > > thanks.
> > >
> > > What about simply removing "wakuep" file if wakeup is not supported?
> > 
> > It may not *stay* unsupported, so I think changing it in either
> > of those permanent ways would be confusing/misleading.
> > 
> > For example, USB devices have multiple states ... minimally, an
> > unconfigured state, and a configured state.  Some have multiple
> > configurations.  Only configured states can be wakeup-capable.
> > So a given device might have three states, but support wakeup
> > except in one of them...
> If so, we can change "unsupported" to "unconfigurable" or "inoperable"
> which can cover the states "unconfigured", "unsupported" and other
> unknown states. :-).

The main problem with your patch is that is changes a documented behavior
visible by the user space.  That should be done very cautiously.

Thanks,
Rafael
