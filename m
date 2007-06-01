Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbXFAPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbXFAPno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbXFAPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:43:37 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56665 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760479AbXFAPng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:43:36 -0400
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Purdie <rpurdie@openedhand.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "kay.sievers" <kay.sievers@vrfy.org>
Cc: "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>,
       Richard Hughes <hughsient@gmail.com>
In-Reply-To: <1180710270.3782.5.camel@localhost.localdomain>
References: <1180710270.3782.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 16:43:12 +0100
Message-Id: <1180712592.6390.139.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 16:04 +0100, Richard Hughes wrote:
> Patch attached corrects all the brokenness with the led class (encoding
> some attributes in the device handle).

For the benefit of LKML, there has been some discussion of this
elsewhere. My arguments do not particularly come across in Richard's
choice of quoting and I'm a little annoyed he's chosen to do things this
way, particularly before any further feedback from Greg/Kay but so be
it.

Greg said that the LEDs class should export any property data as a class
attribute rather than this just being available in the device name. I
added the patch in
http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm to deal
with this, without breaking the existing LED naming and documented API.
Greg said that the only requirement on bus id naming was that it needed
to be unique so this should therefore be compatible. HAL could then go
ahead and ignore the device name, all the attributes are there in the
fashion it needs which was the original complaint.

I accept this is basically out of my hands now. Greg/Kay have the
appropriate emails and if they'll let me know which approach they want
to take, I'll apply an appropriate patch. I'd suggest not applying this
patch directly as it introduces a race in the error path it alters.

Richard


