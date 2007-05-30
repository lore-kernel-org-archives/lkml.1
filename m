Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbXE3OD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbXE3OD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbXE3OC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:02:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbXE3OCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:02:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Wed, 30 May 2007 16:08:27 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org> <1180531067.24891.1.camel@nigel.suspend2.net> <20070530132958.GA28893@srcf.ucam.org>
In-Reply-To: <20070530132958.GA28893@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705301608.28160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 May 2007 15:29, Matthew Garrett wrote:
> On Wed, May 30, 2007 at 11:17:47PM +1000, Nigel Cunningham wrote:
> 
> > That aside, keeping the driver layers read-only sounds more complicated
> > than just freezing processes.
> 
> It's a problem that effectively has to be solved for STR anyway if 
> we're going to suspend without freezing. The midlayers need to be able 
> to block requests when the low-level devices are suspended,

Very true.  And I think the right order should be to make the midlayers do
this and then remove the freezer from the STR code path, not the other way
around. :-)

> so we can just re-use that code.

Yes, that should be possible.

Greetings,
Rafael
