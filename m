Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYCDRx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYCDRx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYCDRxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:53:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50468 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753571AbYCDRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:53:47 -0500
Date: Tue, 4 Mar 2008 12:53:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <200803040144.09601.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803041252480.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:

> Or, as pointed out elsewhere, well-behaved MMC hosts ... which don't
> need either such reprobing or the associated remove-on-suspend.

I don't understand this comment.  Suppose a card was inserted while the 
system was hibernating.  If the core didn't reprobe, when would that 
card be discovered?

Alan Stern

