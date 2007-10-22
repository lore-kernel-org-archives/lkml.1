Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbXJVW5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbXJVW5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXJVW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:57:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbXJVW5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:57:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Regression:  2.6.23-rc9 okay, 2.6.23.1 resume problems
Date: Tue, 23 Oct 2007 01:13:25 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <4712786B.3040009@rtr.ca> <200710170207.02732.rjw@sisk.pl> <471CAF88.2010806@rtr.ca>
In-Reply-To: <471CAF88.2010806@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230113.25667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 October 2007 16:11, Mark Lord wrote:
> Rafael,
> 
> What happens to the jiffies variable on resume from RAM, and from DISK?
> Do we restore it to the value it had at suspend,
> or just leave it be with whatever?
> 
> The answer has to be "restore the value it had at suspend time",
> but I figured I'd check here anyway.
> 
> ??

Well, frankly, I've lost track of that recently, but it seems that we just use
the pre-suspend jiffies (at least in the current -git).

Thomas knows better, I guess. :-)

Greetings,
Rafael
