Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYEOUEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYEOUEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYEOUEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:04:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40077 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYEOUEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:04:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Nottingham <notting@redhat.com>
Subject: Re: Problems with suspend and USB storage
Date: Thu, 15 May 2008 22:04:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Pavel Machek <pavel@ucw.cz>
References: <20080515163315.GA17779@nostromo.devel.redhat.com> <200805152140.43292.rjw@sisk.pl> <20080515194259.GA28848@nostromo.devel.redhat.com>
In-Reply-To: <20080515194259.GA28848@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152204.15828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of May 2008, Bill Nottingham wrote:
> Rafael J. Wysocki (rjw@sisk.pl) said: 
> > Well, the problem is that USB storage devices are disconnected during suspend
> > and hibernation and connected once again during resume.  Then, however, we
> > are not able to tell whether the device in the slot is the same that was in
> > there before the system was put into the sleep state.
> 
> 1) If they're disconnected, how come they work as a hibernate device? Or
>    are they disconnected twice?

They are disconnected right after the image has been loaded, so the resuming
hibernated kernel sees them as disconnected.

> 2) Isn't USB persist supposed to work around this?

That has been changing recently.  Please follow the Alan's advice to debug this
problem.

Thanks,
Rafael
