Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYLOHqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYLOHqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 02:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYLOHqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 02:46:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37835 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYLOHqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 02:46:38 -0500
Date: Mon, 15 Dec 2008 08:46:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Message-ID: <20081215084600.5d237fea@hyperion.delvare>
In-Reply-To: <200812141611.17555.david-b@pacbell.net>
References: <20081212152426.745254309@fluff.org.uk>
	<20081214213349.GA19483@fluff.org.uk>
	<200812141611.17555.david-b@pacbell.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008 16:11:17 -0800, David Brownell wrote:
> On Sunday 14 December 2008, Ben Dooks wrote:
> > Has anyone reveiwed this patch? Are there any comments, or can this
> > be commited at somepoint (even if it is during the next merge window)?
> 
> I was thinking that -EINVAL is almost the least informative
> diagnostic code possible, since so many places return it
> that it's usually hard to find out *which* invalid parameter
> triggered ...
> 
> Is there a less-overloaded code you could return?

-EINVAL sounds right to me, all that's really missing is dev_dbg()
messages in the drivers to log what the exact problem was. 

> I have no issue with the patch other than that.

-- 
Jean Delvare
