Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbYHNTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbYHNTVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYHNTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:21:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbYHNTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:21:10 -0400
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <20080814191726.GG22488@mit.edu>
References: <20080813192922.GI8232@mit.edu>
	 <20080814093103.6CD102FE8B4@pmx1.sophos.com>
	 <20080814132455.GE6469@mit.edu>
	 <1218721713.3540.125.camel@localhost.localdomain>
	 <20080814155028.GB8256@mit.edu>
	 <1218734985.9375.5.camel@paris.rdu.redhat.com>
	 <20080814191726.GG22488@mit.edu>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 15:20:44 -0400
Message-Id: <1218741644.16613.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 15:17 -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 01:29:45PM -0400, Eric Paris wrote:
> > 
> > is i_version an on disk think?  didn't realize that and just assumed it
> > was in in core thing.  I wouldn't have an issue sending i_version to the
> > userspace scanner for them to use as they like.
> > 
> 
> It's on-disk for some filesystems, in order to support NFsv4 advanced
> caching semantics (which means i_version has to survive a reboot,
> which means it has to be on disk).  It is *not* on disk for ext3,
> although it is for ext4.

Is there some pragmatic way in kernel to know if the inode I have
corresponds to a persistent or in core only inode?  I'll poke around
myself and look.

-Eris

