Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYK2U4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYK2U4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYK2U4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:56:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403AbYK2U4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:56:41 -0500
Date: Sat, 29 Nov 2008 12:56:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Garrett <mjg@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       J?rn Engel <joern@logfs.org>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
 behaviour
Message-Id: <20081129125607.55d70063.akpm@linux-foundation.org>
In-Reply-To: <20081129203856.GY25548@parisc-linux.org>
References: <492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
	<20081127170345.GA14991@infradead.org>
	<20081129002419.abfd2504.akpm@linux-foundation.org>
	<20081129130308.GX25548@parisc-linux.org>
	<20081129135742.GC11959@logfs.org>
	<20081129185645.GA20194@shareable.org>
	<20081129190245.GA21502@srcf.ucam.org>
	<20081129123220.67fd1e6a.akpm@linux-foundation.org>
	<20081129203856.GY25548@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 13:38:57 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Nov 29, 2008 at 12:32:20PM -0800, Andrew Morton wrote:
> > The standard, usual, expected way of modifying a filesystem's behaviour
> > is via mount options.  This is also quite flexible.
> > 
> > Is there some extraordinary reason why the standard interface is not to
> > be used here?
> 
> Because it would have to be managed (and consulted) per ... what?
> vfsmount?  superblock?

Per superblock, of course.

> This is featuritis gone MAD.

No it isn't - it's the expected and standard behaviour.  We have all
the kernel infrastructure and userspace tools in place for doing it
this way.

Modifying the behaviour of all filesystems with a single knob is a
weird thing to do.

MNT_RELATIME itself is already per-superblock.
