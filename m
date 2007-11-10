Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXKJQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXKJQJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbXKJQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:09:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:8917 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbXKJQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pc4vk/mf4L5pxW/n5Jg4uh277G+ZBLVFj4V9TH6E0+K5sbAp6rjUGxdt+0Z1sNCa2JNDowUqiX/henRncahCQP0HtUsl8WFqrTR/l6TfBODZhpzKyh8S8qMKgI74SlZxSWZDMnBct87M773MpOZXrDffYNAWrkTMPzF6siYfqhE=
Message-ID: <ef2af3100711100809p41831ab8y7a53916f920a24d8@mail.gmail.com>
Date: Sat, 10 Nov 2007 17:09:40 +0100
From: "Tobias Brox" <tobixen@gmail.com>
To: "Tobias Brox" <tobixen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OOM killer problem - how to read the kernel log?
In-Reply-To: <20071110140212.GA20176@cataract>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com>
	 <20071110140212.GA20176@cataract>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Tobias Brox]
> > We're running 32 bits linux, maybe it would help to upgrade to 64 bits?

[Johannes Weiner]
> Although you can address up to 64GB of RAM with PAE, the address space
> of directly accessible memory is still at 32bit (4GB) and access to
> higher memory costs low memory and processing overhead for the mapping
> into the 32bit address space.

Point taken.  I've gotten quite some replies on this, also off the
list.  We will upgrade to 64 bits, but I don't know when we will get
that done, so now we're wondering what we can do for short-term
solutions.

[Tobias Brox]
> > I've copied out relevant files on
> > http://oppetid.no/~tobixen/oom_problem/ - it's the complete kernel
> > log, /proc/config.gz, /proc/slabinfo, /proc/meminfo and dmesg.  Those
> > are of course fetched after the reboot.

[Hannes]
> kern.log has wrong permissions, slabinfo and meminfo are empty.

My oh my.  I'm really awfully bad at testing things.  Sorry for that.
Links should work now.  Ok, now it's even tested ;-)
