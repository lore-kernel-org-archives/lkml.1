Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZKWKsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZKWKsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZKWKsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:48:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14520 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbZKWKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:48:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=niY+EzjGYIDoQJI8IGpPFBP7Ko7J2w498Etx+PpKNEJak3ElqkRLoFeWsxl/cFdJiL
         olfyhAxDwHc++siwRJMw/MVK0JhBWk6fQu6oLjdRhs6q/+hTgHmjmYfgzVsMkhKIxBa1
         ZiNSoEChjWXs7FawPMpMnoO6FPGQKxBTMN7v8=
Date: Mon, 23 Nov 2009 11:48:32 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
Message-Id: <20091123114832.0a7730a7.kristoffer.ericson@gmail.com>
In-Reply-To: <1258972425.7094.144.camel@johannes.local>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	<mYW9sxtWd2G.A.EnF.gDACLB@chimera>
	<4B08258E.9050607@gmail.com>
	<1258886823.7094.101.camel@johannes.local>
	<20091122162936.ac603ad1.kristoffer.ericson@gmail.com>
	<1258969366.7094.136.camel@johannes.local>
	<20091123105433.d0eb2477.kristoffer.ericson@gmail.com>
	<1258972425.7094.144.camel@johannes.local>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 11:33:45 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2009-11-23 at 10:54 +0100, Kristoffer Ericson wrote:
> 
> > > > > +	hw->wiphy->ps_default = false;
> > > > > +
> 
> > I tried the patch last night as I said, thought that it was working. But not long after
> > sending that email I started seeing those disassociations again (that not appear at all in 2.6.30).
> > So doesnt seem like it was due to that after all. :(
> 
> But then how reliable is your bisect result? The effect of the patch in
> question would've been completely disabled by this line.

Will have to ask Justin about that. 

> 
> johannes


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
