Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbXCDOUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbXCDOUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXCDOUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:20:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbXCDOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:20:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Purdie <rpurdie@openedhand.com>
Subject: Re: [PATCH 8/9] mtd: Allow mtd block device drivers to have a custom ioctl function
Date: Sun, 4 Mar 2007 15:20:42 +0100
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
References: <1172850902.11149.130.camel@localhost.localdomain>
In-Reply-To: <1172850902.11149.130.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041520.43245.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX1/rasHCYAncOCuJKkOV/d6lMR56tMFMd86+2OH
 u7d/O/GhPSN8LKJK1GnVlsrVW+2ghnvMv4iz8DMrYILdHp4HJQ
 nez+38w8WO8hxjFP5Q4cQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 16:55:02 Richard Purdie wrote:
> Allow mtd block drivers to customise their ioctl functions. Also
> allow the drivers to obtain the gendisk struct since ioctl
> functions can need this.

Are you sure that this is a good idea? I'd rather not open
up this method of letting the individual drivers to bad things.

> This also moves the mtd ioctl functions from locked to unlocked.
> As far as I can see, nothing in the mtd code has locking problems.

This part looks fine to me.

	Arnd <><
