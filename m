Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbZHESUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbZHESUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZHESUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:20:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45046 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750867AbZHESUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:20:51 -0400
Date: Wed, 5 Aug 2009 19:20:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805171513.GA10443@kroah.com>
References: <20090805171513.GA10443@kroah.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 10:15:13 -0700
Greg KH <greg@kroah.com> wrote:

> Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.

You seem to have reposted it rather than anyone addressing any of the
complaints people made about ?

To quote Christoph

> What tree did you find with devtmpfs in it?  It was pretty clearly
> rejected when it came up.

and Arjan (who is doing about the fastest Linux boot anyone has and has
better data than anyone else)

> so just to state the obvious: this code is not needed to boot fast.
> It is mostly a workaround for having a bad initrd; if you don't use an
> initrd, or if you use an initrd that's made with the right device nodes
> in it already, you really just don't need this.

> I would much rather that you just fix your initrd... than to put this
> sort of thing into the kernel....

plus 

> Eric has shown that just making the nodes is 0.06 seconds with todays
> sysfs interface, and there is room for improvement,

and Erik Biederman

>> option for us. And still, nobody will be forced
>> to use it, it's entirely optional. For our systems, we decided to do
>> it that way, and we ship it already in the distro, and if there are no
>> substantial problems coming up, which we don't expect, we will
>> continue using it.  

> Yes but you are asking all of us to maintain it.  Forever in perpetuity.
> A better case needs to be made than you have already shipped the code.

Also can you confirm the SELinux issues raised by Stephen Smalley and
David Quigley were fixed and resolved.

Alan
