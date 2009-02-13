Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbZBMQ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbZBMQ1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZBMQ1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:27:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbZBMQ1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:27:42 -0500
Date: Fri, 13 Feb 2009 08:19:28 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.17
Message-ID: <20090213161928.GA24438@suse.de>
References: <20090213013157.GA14377@kroah.com> <49952552.6040000@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49952552.6040000@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 10:46:26AM +0300, Michael Tokarev wrote:
> Greg KH wrote:
> > Here's the announcement of the 2.6.27.17 kernel.
> > 
> > It reverts one patch in the 2.6.27.16 kernel release, which caused an
> > instant oops if you happened to have a laptop with a docking station.
> > Many thanks to David Engel for pointing out the problem.
> 
> > Greg Kroah-Hartman (2):
> >       Revert "ACPI: dock: Don't eval _STA on every show_docked sysfs read"
> >       Linux 2.6.27.17
> 
> I wonder if the same should be done with 2.6.28.5...

No, commit db350b084dc2cf816288643861ce07b0562dd723 is already in
2.6.28, which is needed in order to have the patch that we reverted in
2.6.27.17 work properly.  So it's safe to keep this in the .28-stable
tree.

Unless you or anyone else is having problems with it?  If so, please let
me know.

thanks,

greg k-h
