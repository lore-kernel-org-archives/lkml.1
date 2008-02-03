Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYBDABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYBDABe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 19:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYBDAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 19:01:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbYBDAB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 19:01:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: wakeup code translated to .c
Date: Mon, 4 Feb 2008 00:59:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080130120111.GB22820@elf.ucw.cz> <200802040054.43863.rjw@sisk.pl> <20080203235927.GK2799@elf.ucw.cz>
In-Reply-To: <20080203235927.GK2799@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802040059.38963.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > BTW, I don't like the way in which the 'struct wakeup_header' fields are
> > reproduced in rm/wakeup.S very much, because it makes the code fragile.
> > It might be better to define the offsets in asm-offsets*.c and refer to them
> > relative to wakeup_header (if possible).
> 
> If you can do that.. yes, that would be nice. I triple-checked it, but
> indeed is fragile.

Do you want me to remove the unused fields from 'struct wakeup_header' too?

Rafael
