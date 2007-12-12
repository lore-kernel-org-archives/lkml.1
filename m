Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXLLNpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXLLNpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLLNpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:45:09 -0500
Received: from mxintern.schlund.de ([212.227.126.204]:56775 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXLLNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:45:07 -0500
Date: Wed, 12 Dec 2007 14:43:42 +0100
From: Anders Henke <anders.henke@1und1.de>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, matthew@wil.cx,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)
Message-ID: <20071212134342.GR6770@1und1.de>
Mail-Followup-To: Anders Henke <anders.henke@1und1.de>,
	Miquel van Smoorenburg <miquels@cistron.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <20071212105841.GN6770@1und1.de> <20071212033808.6fb92139.akpm@linux-foundation.org> <1197464879.20796.15.camel@n2o.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197464879.20796.15.camel@n2o.xs4all.nl>
Organization: 1&1 Internet AG
User-Agent: Mutt/1.5.13 (2006-08-11)
X-UI-Msg-Verification: 529b9a563a74a3576646eb97d5b0e29f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.12.2007 schrieb Miquel van Smoorenburg:
> On Wed, 2007-12-12 at 03:38 -0800, Andrew Morton wrote:
> > On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > 
> > > Hi,
> > > 
> > > I'd like to let you now that my boxes are running a 32-bit kernel, so
> > > the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> > > 
> > > http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> > > 
> > > fixed the issue on my testbox.
> > > 
> > > I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.
> > 
> > What a huge patch :(
> > 
> > We already reverted the offening patch so I assume that 2.6.24-rc5 is
> > working for you?
> > 
> > I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
> > model" and then absorbing what Miquel has done there.
> 
> This was just a patch I had lying around, if it worked it would confirm
> my suspicion, which it has.
> 
> The minimal patch which is suitable for 2.6.23-stable and 2.6.24 would
> be the attached one-liner. The "dpt_i2o: convert to SCSI hotplug model"
> patch could be restored then.
> 
> (if the list eats the attachment, it's also available here:
> http://www.miquels.cistron.nl/linux/linux-2.6.23+24-dpt_i2o-dma64.patch 
> )
> 
> Anders, does this one-liner patch work for you ?

Got it - and it works!

I took a clean 2.6.23, applied the patch, recompiled the kernel and
rebooted my testbox: came up with the fresh-compiled kernel 
(verified by "uname -a").


Regards,

Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
