Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196Ab0AGVy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0AGVy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138Ab0AGVy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:54:26 -0500
Received: from mx2.netapp.com ([216.240.18.37]:34801 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab0AGVyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:54:25 -0500
X-IronPort-AV: E=Sophos;i="4.49,237,1262592000"; 
   d="scan'208";a="298825413"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
In-Reply-To: <87zl4pmxzp.fsf@basil.nowhere.org>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 16:53:18 -0500
Message-ID: <1262901198.2659.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 07 Jan 2010 21:54:08.0285 (UTC) FILETIME=[F025FCD0:01CA8FE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 22:00 +0100, Andi Kleen wrote: 
> > Hi Linus,
> >
> > Please pull from the "bugfixes" branch of the repository at
> >
> >    git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes
> >
> > This will update the following files through the appended changesets.
> 
> How about the mmap lock order inversion patch?
> 
> That problem is still there and hits immediately after mounting root 
> with a lockdep warning on any lockdep enabled NFS root kernel.

I'd like to see this fixed, but I do not want to jump onto a solution
that changes the behaviour of mmap() w.r.t. revalidation. The current
behaviour dates back at least to 2.3.x if not before.

That's why I'm working slowly on this.

Cheers
  Trond
