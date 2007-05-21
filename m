Return-Path: <linux-kernel-owner+w=401wt.eu-S1765670AbXEUXVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765670AbXEUXVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbXEUXVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:21:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46280 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629AbXEUXVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:21:06 -0400
Message-ID: <4652295E.7060305@garzik.org>
Date: Mon, 21 May 2007 19:21:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jon Smirl <jonsmirl@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
References: <200705171423.46748.jesse.barnes@intel.com>	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>	 <200705210914.22663.jbarnes@virtuousgeek.org>	 <200705210934.58559.jbarnes@virtuousgeek.org>	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com> <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
In-Reply-To: <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>> 3) Eliminate the need for a root priv controlling process. Get rid of
>> the potential for a security hole.
> 
> Stupid idea, we need something to control policy, this isn't going in
> the kernel, it can be a lot smaller than X and auditable.. sticking
> the DRI protocol in the kernel is just pointless..

It is a quite sensible idea.

The userspace X server SHOULD be running under a non-root user, with 
appropriate fine-grained privs granted to it.

"I need root to do graphics" is a myopic, antiquated view of the world.

	Jeff


