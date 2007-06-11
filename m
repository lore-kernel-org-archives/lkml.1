Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXFKCD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXFKCD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 22:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762209AbXFKCDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 22:03:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbXFKCDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 22:03:21 -0400
Message-ID: <466CAD2D.3070607@zytor.com>
Date: Sun, 10 Jun 2007 19:02:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Pavel Machek <pavel@ucw.cz>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl> <87k5un9l4n.fsf@jbms.ath.cx> <20070604104621.GB4405@elf.ucw.cz> <20070604122054.GB26615@srcf.ucam.org> <20070604131000.GD1971@elf.ucw.cz> <20070604131624.GA27565@srcf.ucam.org>
In-Reply-To: <20070604131624.GA27565@srcf.ucam.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> No, it only supports ext2 (and reading ext3 as if it's ext2). Right now, 
> the assumption that syncing during suspend will cause data to hit 
> something grub can read isn't a safe one.

I brought this issue up quite a few years ago at an OLS BOF.  We pretty
much need a "supersync" system call; you can do this by bmapping any
file on ext3, but having something supported across filesystems would be
good.

	-hpa
