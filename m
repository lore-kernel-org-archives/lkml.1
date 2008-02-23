Return-Path: <linux-kernel-owner+w=401wt.eu-S935298AbYBWIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298AbYBWIpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762714AbYBWIpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:45:03 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:26950 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762024AbYBWIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=N+zK+SyFFRx2g45UhQ0cfW1ScpttiAb+orRGs0hIOND3bSDWyvNV8auLKFEKAtyKicGQFdd9ehy5TMOy4PTQku/aD4HwDtSmXmC5LfHIAMt9K5rnIs6lSWVMyBAJyKjg1RZIoFEjsF1CIUbXsE60Y754iFB6CVHegZeX2C99JVg=
Date: Sat, 23 Feb 2008 11:44:51 +0300
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about your git habits
Message-ID: <20080223084451.GB2262@martell.zuzino.mipt.ru>
References: <200802221837.37680.chase.venters@clientec.com> <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr> <20080223014445.GK27894@ZenIV.linux.org.uk> <7vfxvk4f07.fsf@gitster.siamese.dyndns.org> <20080223020913.GL27894@ZenIV.linux.org.uk> <998d0e4a0802221823h3ba53097gf64fcc2ea826302b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998d0e4a0802221823h3ba53097gf64fcc2ea826302b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 03:23:49AM +0100, J.C. Pizarro wrote:
> On 2008/2/23, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Feb 22, 2008 at 05:51:04PM -0800, Junio C Hamano wrote:
> >  > Al Viro <viro@ZenIV.linux.org.uk> writes:
> >  >
> >  > > On Sat, Feb 23, 2008 at 02:37:00AM +0100, Jan Engelhardt wrote:
> >  > >
> >  > >> >do you tend to clone the entire repository repeatedly into a series
> >  > >> >of separate working directories
> >  > >>
> >  > >> Too time consuming on consumer drives with projects the size of Linux.
> >  > >
> >  > > git clone -l -s
> >  > >
> >  > > is not particulary slow...
> >  >
> >  > How big is a checkout of a single revision of kernel these days,
> >  > compared to a well-packed history since v2.6.12-rc2?
> >  >
> >  > The cost of writing out the work tree files isn't ignorable and
> >  > probably more than writing out the repository data (which -s
> >  > saves for you).
> >
> >
> > Depends...  I'm using ext2 for that and noatime everywhere, so that might
> >  change the picture, but IME it's fast enough...  As for the size, it gets
> >  to ~320Mb on disk, which is comparable to the pack size (~240-odd Mb).
> 
> Yesterday, i had git cloned git://foo.com/bar.git   ( 777 MiB )
> Today, i've git cloned git://foo.com/bar.git   ( 779 MiB )
> 
> Both repos are different binaries , and i used 777 MiB + 779 MiB = 1556 MiB
> of bandwidth in two days. It's much!
> 
> Why don't we implement "binary delta between old git repo and recent git repo"
> with "SHA1 built git repo verifier"?
> 
> Suppose the size cost of this binary delta is e.g. around 52 MiB instead of
> 2 MiB due to numerous mismatching of binary parts, then the bandwidth
> in two days will be 777 MiB + 52 MiB = 829 MiB instead of 1556 MiB.
> 
> Unfortunately, this "binary delta of repos" is not implemented yet :|

See git-pull .
