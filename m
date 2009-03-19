Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZCSUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZCSUPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZCSUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:14:22 -0400
Received: from kroah.org ([198.145.64.141]:35711 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757121AbZCSUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:14:21 -0400
Date: Thu, 19 Mar 2009 13:14:04 -0700
From: Greg KH <greg@kroah.com>
To: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319201404.GD17094@kroah.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com> <6c046ab30903191111y408a6c9g4cb392ad0331c011@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c046ab30903191111y408a6c9g4cb392ad0331c011@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:11:18PM -0400, Sindhudweep Sarkar wrote:
> Of course real support for poulsbo is really important and desirable
> since netbooks make such a huge percentage of computer sales these
> days. I'm guessing, however, that the number of
> embedded/mobile/appliance devices that use or will use the SGX5xx is
> much larger than even the plethora of netbooks being pumped out. If
> more hardware support can be gained for a little extra burden why not
> go for it? I would argue that a unified driver stack would actually
> have less maintenance cost since common bugs could be killed. Even
> ignoring all the arm devices that will use that graphics core, what
> about intel's own use of the SGX 535 elsewhere? Does this "poulsbo"
> driver support the intel CE3100 processors?
> 
> 
> I think i'm really apprehensive about device specific one-offs. Of
> course a mainline driver upstream is an important step to prevent that
> but without a roadmap it only seems marginally better.

Staging is all aobut "device specific one-offs".  the code is then in a
common area where everyone can work to fix it up properly.

I don't want to burry this work again in random git trees that no one
has any clue how to put together, like has already been done in the
past.

thanks,

greg k-h
