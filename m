Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYGAQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYGAQDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759809AbYGAQDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:03:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:47260 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbYGAQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:03:03 -0400
Date: Tue, 1 Jul 2008 09:01:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: Re: [patch 1/9] TTY: fix for tty operations bugs
Message-ID: <20080701160132.GA4496@suse.de>
References: <20080701151057.930340322@mini.kroah.org> <20080701151859.GB3536@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701151859.GB3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:18:59AM -0700, Greg KH wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> This is fixed with the recent tty operations rewrite in mainline in a
> different way, this is a selective backport of the relevant portions to
> the -stable tree.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/hamradio/6pack.c |    2 ++
>  drivers/net/hamradio/mkiss.c |    8 ++++++--
>  drivers/net/irda/irtty-sir.c |    4 +++-

Hm, there are a few build errors with this patch in these two files,
I'll go respin it and do a new -rc release...

Sorry for missing this before.

thanks,

greg k-h
