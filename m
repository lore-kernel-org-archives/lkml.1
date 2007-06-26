Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbXFZKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbXFZKDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXFZKDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:03:19 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:60497 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXFZKDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:03:17 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Purdie <rpurdie@openedhand.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <20070625050606.GC30043@kroah.com>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>
	 <1181343748.9506.116.camel@localhost.localdomain>
	 <20070608234629.GA11723@kroah.com>
	 <1181381117.24811.35.camel@localhost.localdomain>
	 <20070625050606.GC30043@kroah.com>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 11:02:53 +0100
Message-Id: <1182852173.11449.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-24 at 22:06 -0700, Greg KH wrote:
> On Sat, Jun 09, 2007 at 10:25:16AM +0100, Richard Purdie wrote:
> > Anyhow, time to stop pretending I have any choice in this ;-). I will
> > have the LED class use random numbers for busids and add a name
> > attribute unless anyone else voices an opinion.
> 
> Thank you, I really appreciate it, and so does the people who write the
> tools that parse sysfs (like HAL.)

There were some other opinions voiced including one from the person who
started this discussion.

So no, the people who write the tools that parse sysfs (like HAL.) don't
appreciate this.

People who write tools that parse sysfs like shell scripts don't
appreciate it either, as I illustrated.

You've yet to give any technical reason why we can't have meaningful
busids rather than random numbers. Your entire argument seems to be that
its wrong because its a bit different and nobody else does it...

Richard


