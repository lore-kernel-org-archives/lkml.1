Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXF1TPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXF1TPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764938AbXF1TO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:14:58 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:54407 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764807AbXF1TO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:14:57 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Richard Hughes <hughsient@gmail.com>
Cc: Richard Purdie <rpurdie@openedhand.com>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <1182854798.16516.5.camel@work>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>
	 <1181343748.9506.116.camel@localhost.localdomain>
	 <20070608234629.GA11723@kroah.com>
	 <1181381117.24811.35.camel@localhost.localdomain>
	 <20070625050606.GC30043@kroah.com>
	 <1182852173.11449.22.camel@localhost.localdomain>
	 <1182854798.16516.5.camel@work>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 21:15:53 +0200
Message-Id: <1183058153.3479.24.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 11:46 +0100, Richard Hughes wrote:
> On Tue, 2007-06-26 at 11:02 +0100, Richard Purdie wrote:
> > There were some other opinions voiced including one from the person
> > who started this discussion.
> > 
> > So no, the people who write the tools that parse sysfs (like HAL.)
> > don't appreciate this.
> > 
> > People who write tools that parse sysfs like shell scripts don't
> > appreciate it either, as I illustrated.
> 
> >From a hal point of view, we don't care if the device name is 'led01' or
> 'light_to_dance_the_fandango' and from a shell point of view it's
> probably best for the latter. I think the point Greg tried to make is
> that it shouldn't matter, and HAL shouldn't export (nor parse) the
> device name as anything sensible.
> 
> > You've yet to give any technical reason why we can't have meaningful
> > busids rather than random numbers. Your entire argument seems to be
> > that its wrong because its a bit different and nobody else does it...
> 
> If it's a trivial name then I think led_thinklight0 is perfectly okay, I
> think Kay was talking more about the attribute vs. name-in-device
> encoding.

I see no problem to use the function name and add an enumeration number
to that name to be able to handle multiple instances with the same
function name. Like pointed out in earlier mail:
  http://lists.freedesktop.org/archives/hal/2007-May/008552.html

Thanks,
Kay

