Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXKNDgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXKNDgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbXKNDgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:36:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:28550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbXKNDgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:36:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XC+ht+M46/g5IoqXxkS204etsN2Ew2DSOnh8b3Ih/rL6uk0jzzU13aZ2Ofo3g17fO2oP+nS4eV0XPxERdXDXi8nUXM7K22LKq9AoxfSoTAanH+pRkyMmkdp/lmh2MPhZBrF4ivAHioMRrquX4zVnnk9rMMQ9E4Noq/zonUWsaZQ=
Message-ID: <e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
Date: Tue, 13 Nov 2007 20:36:05 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Cc: NeilBrown <neilb@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-raid@vger.kernel.org, M@suse.de, linux-kernel@vger.kernel.org,
       Stable <stable@kernel.org>
In-Reply-To: <20071114002308.GB31928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071022171426.31103.patches@notabene>
	 <20071114002214.GA31928@kroah.com> <20071114002308.GB31928@kroah.com>
X-Google-Sender-Auth: 6da7651dd88d8617
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 5:23 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 13, 2007 at 04:22:14PM -0800, Greg KH wrote:
> > On Mon, Oct 22, 2007 at 05:15:27PM +1000, NeilBrown wrote:
> > >
> > > It appears that a couple of bugs slipped in to md for 2.6.23.
> > > These two patches fix them and are appropriate for 2.6.23.y as well
> > > as 2.6.24-rcX
> > >
> > > Thanks,
> > > NeilBrown
> > >
> > >  [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
> > >  [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
> >
> > I don't see these patches in 2.6.24-rcX, are they there under some other
> > subject?
>
> Oh nevermind, I found them, sorry for the noise...
>

Careful, it looks like you cherry picked commit 4ae3f847 "md: raid5:
fix clearing of biofill operations" which ended up misapplied in
Linus' tree,  You should either also pick up def6ae26 "md: fix
misapplied patch in raid5.c" or I can resend the original "raid5: fix
clearing of biofill operations."

The other patch for -stable "raid5: fix unending write sequence" is
currently in -mm.

> greg k-h

Regards,
Dan
