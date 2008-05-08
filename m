Return-Path: <linux-kernel-owner+w=401wt.eu-S1764981AbYEHTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764981AbYEHTzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYEHTzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:55:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:37779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYEHTzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:55:36 -0400
Date: Thu, 8 May 2008 12:43:14 -0700
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch 00/16] Linux 2.6.25 -stable review
Message-ID: <20080508194314.GA31149@suse.de>
References: <20080508174122.GA855@suse.de> <20080508182233.GB2115@suse.de> <20080508183324.GA1874@1wt.eu> <200805081516.29907.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805081516.29907.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 03:16:28PM -0400, Len Brown wrote:
> On Thursday 08 May 2008, Willy Tarreau wrote:
> > On Thu, May 08, 2008 at 11:22:33AM -0700, Greg KH wrote:
> > > On Thu, May 08, 2008 at 08:13:42PM +0200, Willy Tarreau wrote:
> > > > On Thu, May 08, 2008 at 10:41:22AM -0700, Greg KH wrote:
> > > > > This is the start of the stable review cycle for the 2.6.25.2 release.
> > > > > There are 16 patches in this series, all will be posted as a response to
> > > > > this one.  If anyone has any issues with these being applied, please let
> > > > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > > > to add a Signed-off-by: line to the patch, please respond with it.
> > > > 
> > > > Greg, shouldn't we also queue this one (may be in a later version) ? It's
> > > > in mainline.
> > > 
> > > What problem does it solve?
> > 
> > from what I see in the code, currently acpi_power_get_state() will return
> > 0 when setting resource to NULL, and some callers (eg: acpi_power_on())
> > will happily dereference resource if acpi_power_get_state() returns 0. So
> > I guess there are circumstances where we can oops.
> > 
> > > Does Len want it in -stable?
> > 
> > I simply forgot to ask. I'm CCing him.
> 
> This patch is correct.
> 
> Go ahead and apply it -- it won't hurt anything.
> I don't think it will help anything in real-life either, though.

Ok, because of that, I'll not apply it, we want patches that actually
fix reported problems.

thanks,

greg k-h
