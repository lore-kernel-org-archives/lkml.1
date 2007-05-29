Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXE2Onc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXE2Onc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXE2On0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:43:26 -0400
Received: from waste.org ([66.93.16.53]:36870 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXE2OnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:43:25 -0400
Date: Tue, 29 May 2007 09:43:06 -0500
From: Matt Mackall <mpm@selenic.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tilman Schmidt <tilman@imap.cc>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070529144306.GR11115@waste.org>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46585953.80200@imap.cc> <20070526090117.dda72286.akpm@linux-foundation.org> <465A033C.3070400@imap.cc> <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com> <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 09:25:43AM +0200, Cornelia Huck wrote:
> On Mon, 28 May 2007 00:41:19 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
> > Cornelia,
> > in the patch is:
> >   +	if (dev->kobj.parent == &dev->class->subsys.kobj)
> >   +		return 0;
> > 
> > which will skip the creation of the "device"-link, right?
> 
> ...and this is certainly broken. Argl.
> 
> Could those folks that had trouble with this kernel check out whether
> the following patch helps?

Works for me!

Tested-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
