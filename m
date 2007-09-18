Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXIRUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXIRUeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXIRUeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:34:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47294 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbXIRUeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:34:06 -0400
Date: Tue, 18 Sep 2007 22:35:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, mchan@broadcom.com, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
Message-ID: <20070918203530.GC27836@uranus.ravnborg.org>
References: <46F01BDE.6020902@zytor.com> <20070918.122034.83625273.davem@davemloft.net> <46F02688.8030507@zytor.com> <20070918.130810.78161599.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918.130810.78161599.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 01:08:10PM -0700, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Tue, 18 Sep 2007 12:27:04 -0700
> 
> > Well, what I was referring to here, of course, was the initramfs
> > integrated in the kernel image, so it all comes out of the kernel build
> > tree and produces a single bootable image.  The fact that part of it
> > contains userspace code is in that way invisible.
> > 
> > That was kind of the point here, and the only reason for pushing klibc
> > into the kernel build tree at all.  Under the "distros use external
> > initrd anyway" school of thought, whatever libc used for that can be
> > external anyway.
> 
> Sounds good to me :)

Except there seems to be great resistance to include userland code in the
kernel as demonstrated at last KS. Or this is maybe just a single vocal
person and the topic were brought up late?

Anyway - if we again consider klibc I will do my best to make the
build stuff as smooth as possible.

	Sam
