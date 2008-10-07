Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYJGREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYJGREg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJGRE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:04:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYJGRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:04:28 -0400
Date: Tue, 7 Oct 2008 13:04:04 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andres Freund <andres@anarazel.de>, Tomas Winkler <tomasw@gmail.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Message-ID: <20081007170404.GB5171@bombadil.infradead.org>
References: <200809251511.20132.andres@anarazel.de> <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com> <1223296015.15196.2.camel@johannes.berg> <200810061632.08375.andres@anarazel.de> <1223368636.3778.64.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223368636.3778.64.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 10:37:16AM +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 16:32 +0200, Andres Freund wrote:
> 
> > > Andres, can you post your config?
> > Sure, my current running one is attached.
> > The config I had the error with was exactly the same just with CONFIG_DMAR and 
> > e1000e enabled (but is overwritten now)...
> > 
> > Its no problem trying another branch more debugging options or so if needed.
> 
> No, I was just wondering whether x86-64 had something like powerpc's
> CONFIG_64K_PAGES, but it doesn't seem to. 2M-page support seems to be
> used always dependent on the CPU, but I have no idea you can tell
> whether or not your CPU supports that.
> 

2MB pages (and 4MB pages) are dependent on PSE/PAE, there's no configurable
page size on x86 like there is on other platforms.

PSE gives you 4MB pages, PAE reduces your 4MB pages to 2MB pages (for
extra flag and address bits.)

About the only useful places for these are large mappings like ioremap
and whatnot.

regards, Kyle
