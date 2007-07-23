Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbXGWOci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbXGWOci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbXGWOc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:32:28 -0400
Received: from tim.rpsys.net ([194.106.48.114]:53534 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbXGWOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:32:27 -0400
Subject: Re: [1/2] 2.6.23-rc1: known regressions
From: Richard Purdie <rpurdie@rpsys.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, acpi4asus-u@pimp.vs19.net,
       Gabriel C <nix.or.die@googlemail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <20070723133600.GI21668@ftp.linux.org.uk>
References: <46A47932.8000709@googlemail.com>
	 <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net>
	 <20070723112557.GG21668@ftp.linux.org.uk>
	 <1185196327.6148.51.camel@localhost.localdomain>
	 <20070723133600.GI21668@ftp.linux.org.uk>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 15:32:02 +0100
Message-Id: <1185201122.6148.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 14:36 +0100, Al Viro wrote:
> On Mon, Jul 23, 2007 at 02:12:07PM +0100, Richard Purdie wrote:
> > Fix the leak where asus-led registration fails half way through.
>  
> Frankly, I don't think that any post-factum checks are needed.  We
> should just bail out at the point of failure.  See the patch posted
> earlier...  BTW, your variant does destroy_workqueue() when no
> create_singlethreaded_workqueue() had been called.  FWIW, here's
> the patch I'm talking about:

I saw that after I'd posted mine. I don't mind which we use... 

I'm pleased the IS_ERR(object##_led.class_dev) is gone as that makes
nasty assumptions about what the LED class does internally...

Cheers,

Richard

