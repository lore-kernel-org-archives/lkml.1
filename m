Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYK2UdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYK2UdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYK2UdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:33:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYK2UdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:33:05 -0500
Date: Sat, 29 Nov 2008 12:32:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
 behaviour
Message-Id: <20081129123220.67fd1e6a.akpm@linux-foundation.org>
In-Reply-To: <20081129190245.GA21502@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org>
	<20081126195824.GB3541@srcf.ucam.org>
	<492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
	<20081127170345.GA14991@infradead.org>
	<20081129002419.abfd2504.akpm@linux-foundation.org>
	<20081129130308.GX25548@parisc-linux.org>
	<20081129135742.GC11959@logfs.org>
	<20081129185645.GA20194@shareable.org>
	<20081129190245.GA21502@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 19:02:45 +0000 Matthew Garrett <mjg@redhat.com> wrote:

> On Sat, Nov 29, 2008 at 06:56:45PM +0000, Jamie Lokier wrote:
> 
> > I don't see why there is an objection to per-mountpoint.
> > Andrew Morton's syntax: mount /dev/foo /mnt/bar -o relatime=86400
> > looks natural to me.
> 
> If somebody feels that this functionality would be useful, they're 
> welcome to write it.

If someone writes it, I'll merge it.

> A global default doesn't preclude per-mountpoint 
> settings. This patch makes the existing kernel code more useful and so 
> is worthwhile on its own, even if it doesn't scratch everyone's itch.

The standard, usual, expected way of modifying a filesystem's behaviour
is via mount options.  This is also quite flexible.

Is there some extraordinary reason why the standard interface is not to
be used here?
