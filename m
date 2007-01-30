Return-Path: <linux-kernel-owner+w=401wt.eu-S965394AbXA3OHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394AbXA3OHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965453AbXA3OHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:07:13 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:52158 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965394AbXA3OHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:07:11 -0500
Date: Tue, 30 Jan 2007 23:05:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_platform: fallout from set_mode() change
Message-ID: <20070130140518.GB26984@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jgarzik@pobox.com>, Al Viro <viro@ftp.linux.org.uk>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <E1HBsxd-0002NU-Uz@ZenIV.linux.org.uk> <45BF49DC.3060206@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BF49DC.3060206@pobox.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 08:36:28AM -0500, Jeff Garzik wrote:
> Al Viro wrote:
> >Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> This is already in the queue via Andrew, who caught the same problem.
> 
> Sometimes it seems like you and Andrew are the only people to build on 
> non-x86 these days...
> 
This is the first I've heard of this or the changes that caused this,
while I do build current git on a pretty much daily basis, -mm doesn't
get nearly as much testing.

There are many people who build on non-x86 every day, there are rather
less people who have the bandwidth for -mm as well as current git or
for tracking down changes that haven't made it upstream to make sure
everything plays nice.

If you want immediate action, I suggest you CC the authors of the drivers
when there's changes they should be made aware of, rather than deferring
to hand-waving generalizations about how no one does any testing after
the fact.
