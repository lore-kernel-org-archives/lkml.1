Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXBHXxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXBHXxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965730AbXBHXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:53:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680AbXBHXxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:53:04 -0500
Date: Thu, 8 Feb 2007 15:53:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070208155300.9347e0cb.akpm@linux-foundation.org>
In-Reply-To: <20070208233449.GC18899@athena.road.mcmartin.ca>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070208233449.GC18899@athena.road.mcmartin.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 18:34:49 -0500
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Thu, Feb 08, 2007 at 03:07:10PM -0800, Andrew Morton wrote:
> > I'm getting fed up of holding onto hundreds of patches against subsystem
> > trees, sending them over and over again seeing and nothing happen.  I sent 242
> > patches out to subsystem maintainers on Monday and look at what's still here.
> > 
> > parisc-fix-module_param-iommu-permission.patch
> > pa-risc-fix-bogus-warnings-from-modpost.patch
> > use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
> > 
> >  -> kyle
> > 
> 
> Sorry, I thought the mails meant you were dumping to Linus. Will
> merge.

Once a subsystem has a subsystem tree (git or quilt) I basically never
merge anything which belongs to that tree.  It's always

	originator->mm->subsystemtree->Linus

If the subsystem tree maintainer wants to tell me "I can't be bothered
setting up a git pull for that, please merge it for me" then that's fine.

But unless I'm told that, or unless the maintainer is vacationing or totally
asleep or unless the fix has some sufficiently high obviousness*importance product,
I'll just keep buffering it up.  
