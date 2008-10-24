Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYJXFjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYJXFjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbYJXFi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:38:56 -0400
Received: from kroah.org ([198.145.64.141]:59548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbYJXFi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:38:56 -0400
Date: Thu, 23 Oct 2008 22:36:39 -0700
From: Greg KH <greg@kroah.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
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
       alan@lxorguk.ukuu.org.uk, Alasdair G Kergon <agk@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 11/27] dm exception store: refactor zero_area
Message-ID: <20081024053639.GA17405@kroah.com>
References: <20081024042023.054190751@mini.kroah.org> <20081024043423.GL30828@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024043423.GL30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:34:23PM -0700, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us 
> know.
> 
> ------------------
> From: Alasdair G Kergon <agk@redhat.com>
> 
> commit 7c9e6c17325fab380fbe9c9787680ff7d4a51abd upstream
> 
> Use a separate buffer for writing zeroes to the on-disk snapshot
> exception store, make the updating of ps->current_area explicit and
> refactor the code in preparation for the fix in the next patch.
> 
> No functional change.
> 
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/md/dm-exception-store.c |  103 ++++++++++++++++++++++++++--------------
>  1 file changed, 69 insertions(+), 34 deletions(-)

Oops, this patch causes a build error:

drivers/md/dm-exception-store.c:235: error: implicit declaration of function 'area_location'
drivers/md/dm-exception-store.c:241: error: 'area' undeclared (first use in this function)
drivers/md/dm-exception-store.c:241: error: (Each undeclared identifier is reported only once
drivers/md/dm-exception-store.c:241: error: for each function it appears in.)

I'll drop this one, and the follow-on dm-exception-store.c patch as
well, as that was the only reason this patch was added.

If you want to redo these two patches, and get them into the
2.6.27-stable tree, please do so and send them to stable@kernel.org.

thanks,

greg k-h
