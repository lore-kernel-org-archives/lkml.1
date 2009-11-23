Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZKWJy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZKWJy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZKWJy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:54:28 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39479 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbZKWJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ia5Eg01BvS9cIZDxXjGGeuL5d2yXm6AocZS3LSbdmMhiMuClWCJx/m6EWeqYeY+pO6
         xU2WU44u5qMGhGQ2alBlHpvohI63G90sKPPldFpRlTSIVqO8reZ4RjNaUQ02dQ7+q1xH
         hOkuB+QmKWLVTIaKxfO9EEYkRe6OXl1XCqzRs=
Date: Mon, 23 Nov 2009 10:54:33 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091123105433.d0eb2477.kristoffer.ericson@gmail.com>
In-Reply-To: <1258969366.7094.136.camel@johannes.local>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<mYW9sxtWd2G.A.EnF.gDACLB@chimera>
	<4B08258E.9050607@gmail.com>
	<1258886823.7094.101.camel@johannes.local>
	<20091122162936.ac603ad1.kristoffer.ericson@gmail.com>
	<1258969366.7094.136.camel@johannes.local>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 10:42:46 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Sun, 2009-11-22 at 16:29 +0100, Kristoffer Ericson wrote:
> 
> > > +	hw->wiphy->ps_default = false;
> > > +
> > >  	hw->queues = 4;
> > >  	hw->max_rates = 4;
> > >  	hw->channel_change_time = 5000;
> > > 
> > > 
> > 
> > Johannes, am I correct in thinking that this also solves the decreased signal strength
> > issue in bug http://bugzilla.kernel.org/show_bug.cgi?id=13807 ?
> 
> Unless the driver is really very broken, that's rather unlikely.

I tried the patch last night as I said, thought that it was working. But not long after
sending that email I started seeing those disassociations again (that not appear at all in 2.6.30).
So doesnt seem like it was due to that after all. :(

> 
> johannes


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
