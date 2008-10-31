Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbYJaS3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbYJaS3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYJaS2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:28:53 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55724 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYJaS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:28:53 -0400
Date: Fri, 31 Oct 2008 14:28:46 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
Message-ID: <20081031182846.GP5680@csclub.uwaterloo.ca>
References: <490B2659.9010304@msgid.tls.msk.ru> <20081031155901.GE5682@csclub.uwaterloo.ca> <490B2DDF.5050809@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B2DDF.5050809@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:10:07PM +0300, Michael Tokarev wrote:
> Well, this one is internal reader, which plugs into a 3" slot.
> AND it also has the regular floppy drive in it, too. It's a combo,
> a floppy drive AND a USB flash reader.  As such, I can't easily
> re-plug it (which definitely helps, too, but for that to work I
> have to open the case), and I can't replace it either, because
> this device is almost unique: I still need a floppy and there's
> no other such combo drives, at least I wasn't able to find it.
> It's a great device if you think of it: it connects two epochs
> together...

Yes I use exactly that made by mitsumi.  Never had a problem with the
mitsumi one.  I haven't seen anyone with them lately though, so they
made have been discontinued.

It is shown here though:
http://www.mitsumi.com/products/FA404.htm

I have the one on the right with the floppy at the bottom.

> So at least a) I'm not alone, and b) there's SOMETHING that works.
> Excellent!

That's right.

> The thing is that with some older kernel(s) it defeinitely worked.
> So I'd say it's the kernel which broke/regressed, not the hardware.
> Suggesting to fix the hardware because new kernel does not work with
> it anymore is.. strange at least.

Well the mitsumi I have has worked with every kernel I have ever had
(2.6.26 at the moment).  The no name reader certainly didn't work right
with early 2.6 kernels, and I haven't bothered with it since to check.

> And yes it was definitely a el cheapo no-name thing.  But a..
> great (epochs!) and hence unique thing, see above.. ;)

I think I paid $27(canadian) for my mitsumi.  I paid $20 for the no name
thing (which has no floppy and is external).

> I'll try to find out when it broke.  My first suspect was the patch
> introduced not-so-recently (in 2.6.2x series) to support media
> change notifications done by some hardware (wait for notify instead
> of constantly polling).

Perhaps.  At least you have a simple test case, so a bisect shouldn't be
too hard to do.

-- 
Len Sorensen
