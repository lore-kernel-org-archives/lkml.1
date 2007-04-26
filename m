Return-Path: <linux-kernel-owner+w=401wt.eu-S1031379AbXDZRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031379AbXDZRqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031378AbXDZRqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:46:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44943 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031379AbXDZRqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:46:37 -0400
Date: Thu, 26 Apr 2007 10:45:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <gregkh@suse.de>
Cc: David Lang <david.lang@digitalinsight.com>, linux-kernel@vger.kernel.org,
       cebbert@redhat.com, stable@kernel.org
Subject: Re: [stable] [patch 00/33] 2.6.20-stable review
Message-ID: <20070426174501.GQ2819@sequoia.sous-sol.org>
References: <20070426165445.GA1898@kroah.com> <Pine.LNX.4.63.0704260945090.9674@qynat.qvtvafvgr.pbz> <20070426173028.GA16886@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426173028.GA16886@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (gregkh@suse.de) wrote:
> On Thu, Apr 26, 2007 at 09:48:22AM -0700, David Lang wrote:
> >  any idea why there are so many more -stable patches for 2.6.20? this is the 
> >  10th -stable series, and most of them have been dozens of patches.
> > 
> >  is there a new team reporting and fixing bugs? or were there just more small 
> >  problems found in 2.6.20 then normal? or something else?
> 
> I think it's entirely due to the awesome effort by Chuck Ebbert of Red
> Hat.  He has been digging through all of the applied patches to Linus's
> tree and been forwarding them on to the stable team.  Without his effort
> and help, we would not have so many patches in these releases.

Agreed, Chuck has been really helpful.  AFAIK, he sees it as time
well-spent to make sure -stable is carrying patches so Fedora doesn't
have to, great mantra.

BTW, here's some stats (so it's not that far off from normal):

[chrisw@sequoia linux-2.6-stable]$ for x in $(seq 12 20); do echo linux-2.6.$x.y $(git-rev-list
v2.6.$x..linux-2.6.$x.y | wc -l); done
linux-2.6.12.y 53
linux-2.6.13.y 44
linux-2.6.14.y 96
linux-2.6.15.y 110
linux-2.6.16.y 788
linux-2.6.17.y 191
linux-2.6.18.y 240
linux-2.6.19.y 189
linux-2.6.20.y 235
