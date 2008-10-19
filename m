Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbYJSDbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbYJSDbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 23:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYJSDaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 23:30:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:38926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYJSDav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 23:30:51 -0400
Date: Sat, 18 Oct 2008 20:27:23 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, htejun@gmail.com
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Message-ID: <20081019032723.GA16987@suse.de>
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com> <20081018165939.7b557c2b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018165939.7b557c2b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 04:59:39PM -0700, Andrew Morton wrote:
> On Tue, 9 Sep 2008 19:11:02 -0400 "Parag Warudkar" <parag.lkml@gmail.com> wrote:
> 
> > Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
> > attribute->owner unnecessary.
> > But the field was left in the structure to ease the merge. It's been
> > over a year since that change and it is now time to start killing
> > attribute->owner along with its users - one arch at a time!
> > 
> > This patch is attempt #1 to get rid of attribute->owner only for
> > CONFIG_X86_64 or CONFIG_X86_32 .
> > We will deal with other arches later on as and when possible - avr32
> > will be the next since that is something I can test.
> > Compile (make allyesconfig / make allmodconfig / custom config) and boot tested.
> > 
> > I would prefer to have this in -mm or one of the other trees for some
> > time before hitting mainline just to make sure there are no issues.
> > 
> 
> I'm about to send this in to Linus.

Sounds good to me, thanks for doing this.

greg k-h
