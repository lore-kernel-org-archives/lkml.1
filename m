Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYH0Hpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYH0Hpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYH0HpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:45:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56519 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYH0HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:45:22 -0400
Date: Wed, 27 Aug 2008 09:47:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jassi brar <jassi_singh_brar@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: An idea .... with code
Message-ID: <20080827074751.GO26610@one.firstfloor.org>
References: <87tzd89oap.fsf@basil.nowhere.org> <348573.4171.qm@web33204.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <348573.4171.qm@web33204.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:24:07AM -0700, jassi brar wrote:
> Exceptions(special cases) make for entropy and hence complexity. Generalization keeps uniformity and hences Order and Ease.

I fail to see what your patch generalizes? AFAIK it just adds a new
more narrow (less features than the old one) interface to create loop devices.

> I am not for discarding features from the system, but for implementing them in a way that is lesser intrusive.

But you're adding more code which is more intrusive? 

> > Can you please expand a bit why you think losetup is that complicated
> > and what the problem is with it?
> Sir, i don't object to losetup as such. It is a utility made(specifically?) for LOOP devices: which implements unnecessary gears and switches to operate.
> I object only to what could be done without using ioctls and not to features that losetup provides for devices other than Loop(are there any?)

Your goal is to replace all ioctls with sysfs files? 

If it's that then I'm going on the book as saying that's a bad idea, especially
for this case. While ioctls have their problems they work quite well for many 
things. I don't see any particular reason why ioctls should not be used
to configure loop devices.

-Andi
