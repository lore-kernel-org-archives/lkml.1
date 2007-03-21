Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXCUXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXCUXRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXCUXRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:17:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769AbXCUXRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:17:17 -0400
Date: Wed, 21 Mar 2007 16:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-Id: <20070321161341.0f87ed60.akpm@linux-foundation.org>
In-Reply-To: <20070322001050.13588e5e@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
	<20070320181442.1ae73295@lxorguk.ukuu.org.uk>
	<20070321151952.02b5612d.akpm@linux-foundation.org>
	<20070322001050.13588e5e@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 00:10:50 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > This is a user visible API it is therefore not elligable for removal
> > > anyway
> > 
> > mutter.
> > 
> > We've given people years of notice and _some_ applications have converted
> > over to open("/dev/sda1", O_DIRECT), as they should.
> 
> Linus said we don't break old applications by removing APIs. People
> believe him. 
> 

That's just dogma, and not credible dogma at that.  We regularly remove
features and we have processes for this.

There is no reason why we cannot, with sufficient effort, remove this
driver at some time in the future.

