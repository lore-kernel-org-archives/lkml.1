Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXIXPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXIXPpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbXIXPph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:45:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46104 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbXIXPpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:45:36 -0400
Subject: Re: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
From: Dave Hansen <haveblue@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <3982.1190638701@turing-police.cc.vt.edu>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <3339.1190630150@turing-police.cc.vt.edu>
	 <20070924120508.GA15648@infradead.org>
	 <3982.1190638701@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 08:45:32 -0700
Message-Id: <1190648733.26982.227.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 08:58 -0400, Valdis.Kletnieks@vt.edu wrote:
> > do_times passes an unitialized vfsmount into mnt_want_write.  Here's
> > the quick fix (untested), but the right fix is to restructure the complete
> > mess do_utimes is (never let a libc developer write your kernel code.. :)):
> 
> Close - it still blew up, as one reference to nd.mnt remained.  Fixed patch
> is appended - system boots all the way with this applied.

Any idea which fs and distro this was?  I'd like to add it to my tests.

-- Dave

