Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZFFPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZFFPJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZFFPJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:09:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:35154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZFFPJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:09:24 -0400
Date: Sat, 6 Jun 2009 07:57:56 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Yunpeng Gao <yunpeng.gao@intel.com>, linux-kernel@vger.kernel.org,
       "devel@linuxdriverproject.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
Message-ID: <20090606145756.GA29732@suse.de>
References: <20090606164455.GB27257@intel.com> <4A2A4EF7.7070509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2A4EF7.7070509@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 01:11:51PM +0200, Jiri Slaby wrote:
> On 06/06/2009 06:44 PM, Yunpeng Gao wrote:
> > diff --git a/drivers/staging/mrst_nand/ffsport.c b/drivers/staging/mrst_nand/ffsport.c
> > new file mode 100644
> > index 0000000..5a919f4
> > --- /dev/null
> > +++ b/drivers/staging/mrst_nand/ffsport.c
> > @@ -0,0 +1,953 @@
> > +void glob_udelay(unsigned long usecs)
> > +{
> > +	udelay(usecs);
> > +}
> > +
> > +void glob_mdelay(unsigned long msecs)
> > +{
> > +	mdelay(msecs);
> > +}
> 
> Unneeded wrappers.

<snip>

Thanks for the review, this is one reason why it's in the staging
directory :)

Hopefully someone can send follow-on patches implementing these fixups
(hint...)

greg k-h
