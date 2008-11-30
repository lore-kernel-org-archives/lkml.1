Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbYK3Nun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbYK3Nun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYK3Nue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:50:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45456 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYK3Nud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:50:33 -0500
Date: Sun, 30 Nov 2008 13:50:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix pktcdvd breakage from commit
	e105b8bfc769b0545b6f0f395179d1e43cbee822
Message-ID: <20081130135031.GB28946@ZenIV.linux.org.uk>
References: <20081130121909.GV28946@ZenIV.linux.org.uk> <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com> <20081130132118.GY28946@ZenIV.linux.org.uk> <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com> <20081130133229.GZ28946@ZenIV.linux.org.uk> <20081130134048.GA28946@ZenIV.linux.org.uk> <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 02:44:24PM +0100, Kay Sievers wrote:

> >> Which part of the above constitutes a creation of char device node?
> >
> > Wait a minute...  Are you saying that something in userland ends up
> > seeing that sucker, noticing .../dev and proceeding to do mknod?
> 
> Sure, it does mkod, as the kernel says it should. But that does not
> cause any real problem.

"It" being udev, presumably?

What a mess...  How does drivers/usb/core/devio.c avoid essentially the same
problem?
