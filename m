Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYJ1V2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYJ1V2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYJ1V2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:28:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46421 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ1V2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:28:03 -0400
Date: Tue, 28 Oct 2008 14:26:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karel Zak <kzak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, miklos@szeredi.hu
Subject: Re: [PATCH v2] documentation: split and build smount.c
Message-Id: <20081028142646.3024631b.randy.dunlap@oracle.com>
In-Reply-To: <20080819225625.GG2846@nb.net.home>
References: <20080817214442.ca4345ce.randy.dunlap@oracle.com>
	<20080818050431.GA20692@infradead.org>
	<20080818181409.f2861821.randy.dunlap@oracle.com>
	<20080819225625.GG2846@nb.net.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 00:56:25 +0200 Karel Zak wrote:

> On Mon, Aug 18, 2008 at 06:14:09PM -0700, Randy Dunlap wrote:
> > On Mon, 18 Aug 2008 01:04:31 -0400 Christoph Hellwig wrote:
> > 
> > > Just remove it, and modern /bin/mount handles shared subtrees just fine
> > 
> > Miklos... ?
> > 
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > mount(8) handles shared subtrees just fine, so remove the smount
> > program from Documentation/filesystems/sharedsubtree.txt.
> [...]
> > +	Note: mount(8) command now supports the --make-shared flag,
> 
>  Right, ACK ;-)
> 
> >  	#mount --bind /mnt /tmp
> 
>  BTW, people usually use a space between prompt and command, so:
> 
>    # mount --bind /mnt /tmp

Done for upcoming patch.  Thanks.

---
~Randy
