Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZBERbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZBERbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZBERbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:31:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147AbZBERbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:31:14 -0500
Date: Thu, 5 Feb 2009 09:30:46 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch 30/41] ACPI EC: Fix regression due to use of
	uninitialized variable
Message-ID: <20090205173046.GB27149@suse.de>
References: <20090204184029.881610776@mini.kroah.org> <20090204184648.GE25246@kroah.com> <200902050908.45994.trenn@suse.de> <200902051606.05657.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902051606.05657.trenn@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 04:06:02PM +0100, Thomas Renninger wrote:
> On Thursday 05 February 2009 09:08:42 Thomas Renninger wrote:
> > Hi,
> > 
> > On Wednesday 04 February 2009 19:46:48 Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us
> > > know.
> > Does this one patch cleanly in 2.6.27-stable?
> > I had it on my list, but this seem to have been introduced after
> > 2.6.27 and I thought I removed this one again?
> > Or this is a follow up of another fix that should go in?
> Yes this got in by another patch.
> The huge "make ACPI integer 64 bit aware" one. Which looked like
> it could fix really nasty bugs and is safe due to only long to long long
> conversions. But maybe this wasn't such a good idea, as exported
> kernel functions change from long to long long...

That's ok, there is no "stable abi" requirement for the -stable
releases.

thanks,

greg k-h
