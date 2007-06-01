Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbXFAOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbXFAOvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbXFAOv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:51:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59154 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759716AbXFAOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:51:26 -0400
X-Sasl-enc: 94URudDz5kJvNYVjVrXYOjHtVvYmGNsPZJP48cqk0p/u 1180709485
Date: Fri, 1 Jun 2007 11:51:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Message-ID: <20070601145121.GC8211@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <200705312333.11477.dtor@insightbb.com> <20070601040824.GA5042@srcf.ucam.org> <200706010037.59496.dtor@insightbb.com> <20070601131324.GB12204@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601131324.GB12204@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Matthew Garrett wrote:
> Or we could just leave the mapping up to individual users, which avoids 
> the problem.

Other than the fact that it is not a piece of candy to implement correctly.

> > Again, it is not only about X. What if X is not running (or running but
> > nobody is logged in)? There are number of events (SUSPEND, WLAN switch,
> > undock request, etc) that should be handled by daemons not depending
> > on X.
> 
> The existing implementations use X. I don't think any of the desktop 
> distributions really care about the non-X case for this sort of thing.

Debian does, for one.  And I am pretty sure it is not the only one.

Also, let me state right now that IMO, this "I need X to be running and
logged in" for dock, eject, suspend, wlan on/off and other *system* level
activity to work is an extremely bad idea and broken on so many levels it is
not funny.

I have nothing against allowing such activities to be *modified* to suit the
logged in user, subject to approval by the system administrator.  But to
have them implemented in that level? Yuck.

But I don't see what this means for input device keyboard maps.  Any of the
proposed solutions to the problem so far will work equally well (or not well
:) ) for console and X users, even the "lots of KEY_UNKNOWN" one...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
