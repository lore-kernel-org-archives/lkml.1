Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbZGQAZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbZGQAZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933810AbZGQAZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:25:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:51439 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933734AbZGQAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:25:00 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090716094135.4e6c9ba0@lxorguk.ukuu.org.uk>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714161514.GA2026@kroah.com>
	 <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
	 <20090716094135.4e6c9ba0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 10:24:23 +1000
Message-Id: <1247790263.27937.75.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 09:41 +0100, Alan Cox wrote:
> > We don't have a device in this case, vga arb is more of an abstraction than
> > an actual device.
> > 
> > I suppose if we were feeling crazy we could add a platform device for it.
> 
> Probably a good idea and it gives you something more meaningful to hang
> the list of devices being arbitrated.

That's a good point, it would be useful for diagnosis purposes at least
to have a sysfs dir with symlinks to the devices being arbitrated.

Cheers,
Ben.


