Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZJBXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZJBXqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZJBXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:46:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbZJBXqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:46:30 -0400
Date: Fri, 2 Oct 2009 16:00:18 -0700
From: Greg KH <gregkh@suse.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/48] 2.6.27.32-stable review
Message-ID: <20091002230018.GA1479@suse.de>
References: <200909112223.n8BMMSHG002530@hera.kernel.org>
 <20090916210956.GB24567@kroah.com>
 <4AB387E3.6030709@imap.cc>
 <20091001153017.GA6058@kroah.com>
 <4AC68086.8020100@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC68086.8020100@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 12:36:54AM +0200, Tilman Schmidt wrote:
> Am 01.10.2009 17:30 schrieb Greg KH:
> > On Fri, Sep 18, 2009 at 03:15:15PM +0200, Tilman Schmidt wrote:
> >>
> >> So commit 221418f9a25cd96aff99d6aba41c177f6eb00853 should be reverted and
> >> my original patch below applied instead. The patch by Stefan Bader is
> >> equivalent to that but additionally backports two pr_err() calls from
> >> mainline.
> > 
> > I took Stefan's patch as it was simpler.  Let me know if the problem is
> > still present.
> 
> Stefan's patch is fine. I just did a quick test of
> fix-incorrect-stable-backport-to-bas_gigaset.patch
> on top of 2.6.27.35 and the problem is gone.

Great, thanks for testing and letting me know.

greg k-h
