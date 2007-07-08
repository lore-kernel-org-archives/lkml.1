Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXGHURX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXGHURX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXGHURQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:17:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4278 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756665AbXGHURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:17:15 -0400
Date: Sun, 8 Jul 2007 16:17:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <1183871941.3388.286.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707081616230.11049-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Benjamin Herrenschmidt wrote:

> Note that we could have also a per-device "icebox" (just a waitqueue).
> Might be nice for a device to resume whatever it froze just after it
> resumed itself, might even be necessary in case whatever thread got
> frozen is necessary for handling child devices.

This wouldn't need any special infrastructure.  Just a regular 
waitqueue defined in the device's private data structure.

Alan Stern

