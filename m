Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYLOKQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYLOKQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYLOKQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:16:26 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60910 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751961AbYLOKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:16:25 -0500
Date: Mon, 15 Dec 2008 10:16:16 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Message-ID: <20081215101616.GB12431@fluff.org.uk>
References: <20081212152426.745254309@fluff.org.uk> <20081214213349.GA19483@fluff.org.uk> <200812141611.17555.david-b@pacbell.net> <20081215084600.5d237fea@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215084600.5d237fea@hyperion.delvare>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 08:46:00AM +0100, Jean Delvare wrote:
> On Sun, 14 Dec 2008 16:11:17 -0800, David Brownell wrote:
> > On Sunday 14 December 2008, Ben Dooks wrote:
> > > Has anyone reveiwed this patch? Are there any comments, or can this
> > > be commited at somepoint (even if it is during the next merge window)?
> > 
> > I was thinking that -EINVAL is almost the least informative
> > diagnostic code possible, since so many places return it
> > that it's usually hard to find out *which* invalid parameter
> > triggered ...
> > 
> > Is there a less-overloaded code you could return?
> 
> -EINVAL sounds right to me, all that's really missing is dev_dbg()
> messages in the drivers to log what the exact problem was. 

It might be more acceptable to be dev_err(), that way it will get
printed no matter what debug options have been selected. If so, a
seperate patch is probably in order to make the change.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
