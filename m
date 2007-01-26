Return-Path: <linux-kernel-owner+w=401wt.eu-S1030638AbXAZPDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030638AbXAZPDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXAZPDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:03:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:46986 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030638AbXAZPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tt3GCAQ80726qBB70Zbrw9d1fAC53SduIcyVhyMAPoDJ21R6ii45/l+6Iz2/8ny0L0565lAt43xw26HSm5xrXbOtHI7s1uHE4YJyhQjj31zyRmK6xLQ6VdkwBexFWxpfjxwiyQmIxldpN80N7zaKpeDFMIkOVOKqEVaaVgntOus=
Message-ID: <3877989d0701260703q37bd586awabdeb172f63a8018@mail.gmail.com>
Date: Fri, 26 Jan 2007 23:03:14 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Martin Drab" <drab@kepler.fjfi.cvut.cz>
Subject: Re: Intel PCI-E bridge ACPI resources and possibly related SATA unstability problems on ASUS A8Js
Cc: "Oleg Verych" <olecom@flower.upol.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701261320260.6213@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701250142180.14408@kepler.fjfi.cvut.cz>
	 <E1HA1Se-0002Y3-VQ@flower>
	 <Pine.LNX.4.64.0701251325250.20484@kepler.fjfi.cvut.cz>
	 <20070125135813.GB9917@flower.upol.cz>
	 <Pine.LNX.4.64.0701261320260.6213@kepler.fjfi.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/07, Martin Drab <drab@kepler.fjfi.cvut.cz> wrote:
> On Thu, 25 Jan 2007, Oleg Verych wrote:
>
> > On Thu, Jan 25, 2007 at 01:28:56PM +0100, Martin Drab wrote:
> > > On Thu, 25 Jan 2007, Oleg Verych wrote:
> > >
> > > > gmane.linux.kernel:
> > > > > recently I got my hands on an ASUS A8Js notebook (Core 2 Duo T7200,
> > > > > Intel 945 PM PCI-E Chipset, for details see attached log). After booting
> > > > > the latest 2.6.20-rc5-git3 kernel (but the same behaviour occurs also with
> > > > > the 2.6.19.2, didn't try any other), some strange behaviour can be
> > > > > observed.
> > > >
> > > > There were disscussions about mmconfig and what nightmare it brought to
> > > > PCI(E) configuration in scope of BIOS, chip bugs. Here's (one of) such:
> > > > <http://marc.theaimsgroup.com/?l=linux-kernel&m=116007091004503&w=2>
> > > >
> > > > > At first the following messages appear in the log:
> > > > >
> > > > > ...
> >       [   40.303154] PCI: BIOS *Bug*: MCFG area at e0000000 is not E820-reserved
> > > > > [   40.303157] PCI: Not using MMCONFIG.
> > > > >
> > > > > (not sure whether this is really a problem)
> > > >
> > > > I think it may be the major problem.
> > >
> > > Hmm, it may be. Was there suggested any solution (or at least proposal)
> > > that I may try?
> >
> > Try fix BIOS bugs: <http://permalink.gmane.org/gmane.linux.kernel/462632>
>
> ASUS refused to help fixing the BIOS with words that ASUS notebooks do not
> support Linux. So if we do not workaround this somehow, Linux would really
> be unusable on this HW. :(
>
Does pci=nommconf work for you. Also why not use memmap=exactmap  ...
boot command line to workaround this bios bug?
