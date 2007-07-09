Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXGILt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXGILt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXGILtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:49:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXGILtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:49:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 13:56:44 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081619090.11049-100000@netrider.rowland.org> <200707090852.03429.oliver@neukum.org> <1183972449.5961.28.camel@localhost.localdomain>
In-Reply-To: <1183972449.5961.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091356.45486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 9 July 2007 11:14, Benjamin Herrenschmidt wrote:
> On Mon, 2007-07-09 at 08:52 +0200, Oliver Neukum wrote:
> > Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > Another issue that's been a problem forever with suspend is the
> > > synchronous request_firmware interface. Lots of drivers do that in
> > > resume() which will generally not work.
> > 
> > Unfortunately yes they do. We now have the notifier chains, which
> > can be used. Firmware, especially if it is large, must be requested
> > while the system is still fully functional and paging will work.
> > 
> > Asynchronocity will not help much because the devices must work
> > after resumingand delaying that will not help with respect to needing
> > devices to get at the firmware.
> 
> True, pre-loading is the best approach.

Agreed.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
