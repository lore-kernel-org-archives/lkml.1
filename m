Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbXJDJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbXJDJDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJDJDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:03:41 -0400
Received: from ns.suse.de ([195.135.220.2]:40035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbXJDJDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:03:40 -0400
From: Andi Kleen <ak@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
Date: Thu, 4 Oct 2007 11:01:46 +0200
User-Agent: KMail/1.9.1
Cc: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20071003013413.GA17717@havoc.gtf.org> <4703161E.8040603@zytor.com> <4703CA28.9010609@redhat.com>
In-Reply-To: <4703CA28.9010609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041101.46794.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 18:58, Chuck Ebbert wrote:
> On 10/03/2007 12:10 AM, H. Peter Anvin wrote:
> > Randy Dunlap wrote:
> >> Maybe we can/should merge the doc files along with the x86 arch merge.
> >
> > Well, the x86 merge is pretty much mechanical.  It should be followed up
> > with a lot of manual merging.
>
> It would be really nice if identical kernel parameters used the same names,
> so people didn't waste their time trying e.g. "nolapic_timer" on x86_64
> because that option fixed their problems on i386 (it's "noapictimer" in
> x86_64.)

Well the x86-64 option was there first; you have to ask whoever
added the i386 option why they used a different name

But I normally added aliases as people reported them. Nobody did in 
this case.

One reason is probably that noapictimer is not very useful on x86-64 --
the nolapic_timer is really more a workaround that only started making
sense on HRT because it made "apicmaintimer" default. 
On current x86-64 which doesn't do that there is very little reason to use it
and you'll usually just break things.

So I guess the real reason is that they're not actually identical
when you look closely.

-Andi

