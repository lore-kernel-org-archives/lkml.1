Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZKKQRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZKKQRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZKKQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:17:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:34770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZKKQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:17:40 -0500
Date: Wed, 11 Nov 2009 08:19:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111081905.270a4e55@infradead.org>
In-Reply-To: <4AFA6AEF.5060306@garzik.org>
References: <20091025225342.007138f5@infradead.org>
	<20091111020108.GA11423@localhost>
	<20091110223456.01ef355f@infradead.org>
	<4AFA6AEF.5060306@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 02:42:39 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> On 11/11/2009 01:34 AM, Arjan van de Ven wrote:
> > Wu Fengguang<fengguang.wu@intel.com>  wrote:
> >> Maybe this is enough for POWERTOP, however for general use, the
> >> dirty type(data/metadata) and inode number may be valuable to some
> >> users?
> >
> > what can a user do with an inode number????
> 
> Inode numbers have always been visible to userspace...  IIRC, tar(1) 
> uses the st_ino member of struct stat to detect hard links in certain 
> cases.  ls(1) displays inode numbers with -i, find(1) looks for them 
> with -inum, ...

ok let me rephrase that. What would a user DO with this inode number
information, given that the filename is already passed on;
what additional useful, not-infinitely-hard-to-get piece of information
does this give the user that he can use to do <something> that he cannot
do with the current information ? E.g. what is that <something> ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
