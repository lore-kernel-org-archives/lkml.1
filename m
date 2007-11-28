Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXK1R5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXK1R5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXK1R5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:57:05 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33727 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbXK1R5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:57:04 -0500
Date: Wed, 28 Nov 2007 12:30:22 -0500
To: Jean Delvare <khali@linux-fr.org>
Cc: Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128173022.GD2308@csclub.uwaterloo.ca>
References: <20071024162528.GX30533@stusta.de> <20071024164347.GN4003@csclub.uwaterloo.ca> <20071128112357.3828d469@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128112357.3828d469@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:
> There's no driver to write (i2c-gpio is the driver). Instead, the
> scx200 platform needs to implement the standard GPIO API. I don't think
> that it has happened yet, and last time this was discussed, someone
> (can't remember who, sorry), complained that the GPIO API "sucked" and
> that the scx200 platform would not be updated to use it. I didn't buy
> the claim due to a lack of argumentation and the fact that the GPIO
> infrastructure seems to work well enough for many other platforms.
> 
> As far as I can see, the ixp2000 platform also doesn't implement the
> standard GPIO API yet, so of the 3 drivers that are about to be
> removed, only i2c-ixp4xx can be removed without functionality loss at
> the moment. Lennert, Russell, are there any plans to convert the
> ixp2000 platform to use the generic GPIO layer?
> 
> Maybe I shouldn't have added this entry in feature-removal-schedule.txt
> in the first place: these drivers should ideally be dropped in favor of
> i2c-gpio, but it can only happen for platforms that implement the
> standard GPIO API. As I am not the one who will convert these
> platforms, and some of them might as well never be converted (I don't
> know how active they are nowadays), there's not much I can do.

Well if I get a chance I might try to do it for the scx200 at some point
(since I do use it) although given the current i2c driver works just
fine and I have no need for the rest of the gpio lines what so ever
there isn't that much insentive to do so yet.

Removing the existing i2c driver would seem like a mistake at this time
though.

--
Len Sorensen
