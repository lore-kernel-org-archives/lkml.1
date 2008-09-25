Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYIYULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYIYULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYIYULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:11:08 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:26234 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYIYULH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:11:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [Bug 11603] Re: ACPI PnP on Intel MU440EX
Date: Thu, 25 Sep 2008 13:53:55 -0600
User-Agent: KMail/1.9.9
Cc: Martin Doucha <next_ghost@quick.cz>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
References: <48BA9B2C.7060007@quick.cz> <200809241705.13410.bjorn.helgaas@hp.com> <48DBDDE6.3060301@free.fr>
In-Reply-To: <48DBDDE6.3060301@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251353.55554.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aren't parport still probing it's own port if pnp failed ?

Could be; I haven't looked.  I just assumed parport didn't do the
legacy probe because Martin reported that the port didn't work when
PNPACPI was enabled.

And I retract my "parport.nopnp" idea.  A positive statement like
"parport.legacy" or something along the lines of "look here" would
be better.  It's safe to use PNP to probe; it just won't find anything.
All we want is something to tell parport to do the legacy probe in
addition.

