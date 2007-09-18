Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXIROHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXIROHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXIROH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:07:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37520 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbXIROH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:07:27 -0400
Date: Tue, 18 Sep 2007 16:07:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Falk <oliver@linux-kernel.at>
Cc: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
Message-ID: <20070918140738.GD27980@stusta.de>
References: <46EEE483.4020209@linux-kernel.at> <20070917214107.GB27980@stusta.de> <46EF90A3.2050109@linux-kernel.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EF90A3.2050109@linux-kernel.at>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 10:47:31AM +0200, Oliver Falk wrote:
> On 09/17/2007 11:41 PM, Adrian Bunk wrote:
> > On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
> >> Hi!
> > 
> > Hi Oliver!
> > 
> >> ...
> >> As these additions are quite new to upstream kernel, but at Alphacore we
> >> have patched it since a while now (I don't know about other Alpha ports;
> >> Debian folks may speak up now!), I would suggest to use the same
> >> 'ordering' of the syscalls upstream and add the new syscalls that we had
> >> not in place, but are now upstream to the end of our 'old' list.
> >> ...
> > 
> > I just checked:
> > 
> > It seems Debian didn't patch them into the kernel at all, and since two 
> > months Debian unstable ships kernel 2.6.22 with the upstream syscall 
> > numbers.
> 
> That's possible a problem. Right. Someone with contacts to Debian here?
> If Debian hasn't rebuilt glibc against the new headers, we could change
> it without problems.
>...

According to the Debian auto-builder database [1], the Alpha glibc 
package in Debian unstable has been rebuilt 8 times since the 2.6.22 
kernel packages entered Debian unstable.

And it's not only Debian, at least Gentoo also offers an Alpha port.

> Best,
>  Oliver

cu
Adrian

[1] http://buildd.debian.org/build.php?arch=alpha&pkg=glibc

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

