Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZCDK3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZCDK3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZCDK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:29:26 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18597 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZCDK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:29:25 -0500
Date: Wed, 4 Mar 2009 12:12:31 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Message-ID: <20090304101231.GS4640@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090228141725.ZZRA012@mailhub.coreip.homeip.net> <20090301003014.GA22673@frodo> <20090228165156.ZZRA012@mailhub.coreip.homeip.net> <20090301144018.GA23581@frodo> <20090304090026.GC7394@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304090026.GC7394@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 04 Mar 2009 10:28:50.0492 (UTC) FILETIME=[0263EFC0:01C99CB4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 10:00:27AM +0100, ext Dmitry Torokhov wrote:
> On Sun, Mar 01, 2009 at 04:40:19PM +0200, Felipe Balbi wrote:
> > On Sat, Feb 28, 2009 at 04:58:01PM -0800, Dmitry Torokhov wrote:
> > > On Sun, Mar 01, 2009 at 02:30:18AM +0200, Felipe Balbi wrote:
> > > > On Sat, Feb 28, 2009 at 02:23:03PM -0800, Dmitry Torokhov wrote:
> > > > > Hi Felipe,
> > > > > 
> > > > > On Fri, Feb 27, 2009 at 09:28:02PM +0200, Felipe Balbi wrote:
> > > > > > From: Felipe Balbi <felipe.balbi@nokia.com>
> > > > > > 
> > > > > > This is part of the twl4030 multifunction device driver.
> > > > > > 
> > > > > > With this driver we add support for reporting KEY_POWER
> > > > > > events via the input layer.
> > > > > 
> > > > > ...
> > > > 
> > > > thanks for reviewing, how about the version below:
> > > > 
> > > 
> > > Looks good, couple more items...
> > 
> > Fixed the extra comments and also got rid of the global input_dev
> > structure. It could be fetched by passing it to request_irq() and
> > platform_set/get_drvdata():
> > 
> 
> Cool, I will keep it in my tree pending the threaded IRQ issue
> resolution.

I guess the threaded IRQ issue will still take a while to be solved and
this driver is working as is, so there's no big problem in pushing it
and fixing the threaded irq on later patches. But I'd like to hear from
Andrew, Dave and the others about that.

-- 
balbi
