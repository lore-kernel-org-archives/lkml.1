Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbZFNQ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbZFNQ2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZFNQ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:27:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbZFNQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:27:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
Date: Sun, 14 Jun 2009 18:28:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <1244996001.8440.10.camel@localhost>
In-Reply-To: <1244996001.8440.10.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141828.11970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Thomas Meyer wrote:
> Hello.
> 
> After a cold start of the computer, the first suspend-to-ram works as it
> should and everything is fine.
> 
> But after waking up again, the second suspend-to-ram (in a row) seems to
> work, but the computer wakes up immediately (i.e. it doesn't stay in
> S3)!
> 
> Now the strange part: after re-plugging my 4-port usb hub, the computer
> (in a third suspend-to-ram try) enters S3 without waking up immediately
> again.
> 
> Strange, hmm?

So, it looks like there's a device that generates a wake-up request after the
second suspend automatically.

Can you send the output of lspci from the box?

Rafael
