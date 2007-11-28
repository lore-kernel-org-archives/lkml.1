Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbXK1TEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbXK1TEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbXK1TEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:04:11 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57120 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757668AbXK1TEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:04:10 -0500
Date: Wed, 28 Nov 2007 14:04:09 -0500
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Adrian Bunk <bunk@kernel.org>, i2c@lm-sensors.org,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128190409.GE2308@csclub.uwaterloo.ca>
References: <20071024162528.GX30533@stusta.de> <20071024164347.GN4003@csclub.uwaterloo.ca> <20071128112357.3828d469@hyperion.delvare> <20071128173022.GD2308@csclub.uwaterloo.ca> <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:43:00PM -0500, Jon Smirl wrote:
> Hasn't their been a one year notice that these drivers were going to
> be removed? How about removing them and putting them into a tarball on
> the i2c web site with a note explaining about how they need to be
> updated to use the gpio driver? Then if someone really wants to use
> the old drivers they can use them out of tree.

Why remove a working driver?  Who gets to decide that everyone must go
use this gpio api based system that isn't yet supported by all
platforms?  If someone thinks the old drivers should be replaced by new
ones using the new GPIO API then they should go implement it, and then
when it works they can remove the old one.  You can't just declare that
you think the old one sucks and should be removed and if anyone else
cares they should go make a working driver to replace it.

--
Len Sorensen
