Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYCQXWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYCQXWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYCQXWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:22:42 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:35158 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYCQXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:22:42 -0400
Message-ID: <fa686aa40803171622j2183369ei7b384ada72d329d6@mail.gmail.com>
Date: Mon, 17 Mar 2008 17:22:30 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Gortmaker" <paul.gortmaker@windriver.com>
Subject: Re: powerpc: cuImage.* creation error
Cc: "Adrian Bunk" <bunk@kernel.org>, "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080317224607.GA10732@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317193652.GA9550@cs181133002.pp.htv.fi>
	 <20080317200754.GA7383@windriver.com>
	 <fa686aa40803171541t6357d304i2e7e5292f084d09d@mail.gmail.com>
	 <20080317224607.GA10732@windriver.com>
X-Google-Sender-Auth: dde4a5b6825dbf55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 4:46 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> In message: Re: powerpc: cuImage.* creation error
>
>
> on 17/03/2008 Grant Likely wrote:
>
>  > On Mon, Mar 17, 2008 at 2:07 PM, Paul Gortmaker
>  > <paul.gortmaker@windriver.com> wrote:
>  > > In message: powerpc: cuImage.* creation error
>  > >
>  > >  @@ -253,8 +253,8 @@ image-$(CONFIG_TQM8540)                     += cuImage.tqm8540
>  > >   image-$(CONFIG_TQM8541)                        += cuImage.tqm8541
>  > >   image-$(CONFIG_TQM8555)                        += cuImage.tqm8555
>  > >   image-$(CONFIG_TQM8560)                        += cuImage.tqm8560
>  > >  -image-$(CONFIG_SBC8548)                        += cuImage.tqm8548
>  > >  -image-$(CONFIG_SBC8560)                        += cuImage.tqm8560
>  > >  +image-$(CONFIG_SBC8548)                        += cuImage.sbc8548
>  > >  +image-$(CONFIG_SBC8560)                        += cuImage.sbc8560
>  >
>  > No, the suffix in the cuImage targets has a 1:1 relationship with dts
>  > files in arch/powerpc/boot/dts/.  If a file doesn't exist there, then
>  > the target cannot be built.
>
>  You should have both the sbc8548.dts and the sbc8560.dts in your tree.
>  They have been in there for several weeks now.

Heh; oops.  I looked but somehow missed them.  I guess I didn't look
hard enough.

Yes, this looks like the right solution.

>  Author: Paul Gortmaker <paul.gortmaker@windriver.com>
>  Date:   Mon Mar 17 18:33:52 2008 -0400
>
>     wrapper: Add entries for tqm8540 and sbc85xx
>
>     The wrapper script didn't have entries for the TQM8540 board and the
>     SBC8548 or SBC8560 boards.  I've assumed that the TQM8540 console is
>     8250 based and not CPM based by looking at its defconfig.  There was
>     also a trailing * on the TQM8555 entry that I removed too.
>
>
>     Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>

Cheers,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
