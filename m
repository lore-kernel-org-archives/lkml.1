Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYLCX2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYLCX2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYLCX2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:28:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:45907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYLCX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:28:12 -0500
Date: Wed, 3 Dec 2008 15:19:00 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Tokarev <mjt@tls.msk.ru>
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
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 000/104] 2.6.27-stable review
Message-ID: <20081203231900.GC632@suse.de>
References: <20081203194725.GA8950@kroah.com> <493702CC.5030804@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493702CC.5030804@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 01:06:04AM +0300, Michael Tokarev wrote:
> Greg KH wrote:
> []
> > And yes, there are a lot of patches here, the big series are:
> ...
> > 	- ext4 bugfixes
> 
> I wonder why updates for ext4, which is still marked
> "experimental" in kconfig, should go to -stable in
> the first place...  Given the number of bugs^Wpatches
> in this part of the kernel, and given the amount
> of current development in this area.  Just.. curious.

Primarily because at least 4 distros are basing their releases off of
the 2.6.27 kernel tree.  Those distos do have users who are using the
ext4 file system for their daily use, and so bugfixes for it are worthy
to keep track of in a centralized place like the -stable tree.

thanks,

greg k-h
