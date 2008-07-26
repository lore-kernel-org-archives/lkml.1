Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYGZVHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYGZVHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYGZVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:07:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189AbYGZVG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:06:59 -0400
Date: Sat, 26 Jul 2008 15:04:46 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan <alan@clueserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: Problem mounting Motorola USB device
Message-Id: <20080726150446.7274b37d.zaitcev@redhat.com>
In-Reply-To: <1217103320.22476.0.camel@rotwang>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
	<20080725235122.0e097f1f.akpm@linux-foundation.org>
	<20080726112249.1ade4980.zaitcev@redhat.com>
	<1217096347.5892.1.camel@rotwang>
	<20080726123348.782a2776.zaitcev@redhat.com>
	<1217103320.22476.0.camel@rotwang>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.13.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 13:15:20 -0700, Alan <alan@clueserver.org> wrote:
> On Sat, 2008-07-26 at 12:33 -0600, Pete Zaitcev wrote:

> > One question: can you switch to self-built kernels instead of supplied
> > by Fedora, just for this bug? It would be easier for me to look at
> > (I'm speaking in the USB hacker capacity here rather than as one
> > of Chuck's underlings).
> 
> Which tree do you want me to build from?

I think 2.6.26 would be a good place to start. Also I think the best would
be to populate the .config from /boot/config* that Fedora supplies. It takes
longer to build, but makes it more likely that we reproduce one or both
of the failures you saw (phone not mounted and the oops). You will need
to run  mkinitrd /boot/initrd-2.6.26-alan.img 2.6.26-alan or something
like it, Fedora's userland and .config pretty much require it.

-- Pete
