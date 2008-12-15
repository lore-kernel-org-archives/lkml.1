Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYLOKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYLOKP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYLOKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:15:50 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60906 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751545AbYLOKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:15:49 -0500
Date: Mon, 15 Dec 2008 10:15:25 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Message-ID: <20081215101524.GA12431@fluff.org.uk>
References: <20081212152426.745254309@fluff.org.uk> <20081214213349.GA19483@fluff.org.uk> <200812141611.17555.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812141611.17555.david-b@pacbell.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 04:11:17PM -0800, David Brownell wrote:
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

The only other ones that I think would be close are:

       ENOTSUP         Operation not supported (POSIX.1)
       EPROTO          Protocol error (POSIX.1)
       ENOENT	       No such file or directory
       EFAULT	       Bad address

Feedback welcone.
 
> I have no issue with the patch other than that.
> 
> - Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
