Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbZBMOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbZBMOH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZBMOHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:07:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZBMOHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:07:13 -0500
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
From: Peter Zijlstra <peterz@infradead.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
In-Reply-To: <49957C43.7050701@gmail.com>
References: <18837.24581.181196.569183@edward.zelnet.ru>
	 <1234530519.6519.46.camel@twins>  <49957C43.7050701@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 15:09:10 +0100
Message-Id: <1234534150.6519.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 16:57 +0300, Edward Shishkin wrote:
> >
> > Eew, so reiser4 will totally side-step the regular vm inode
> writeback
> > paths -- or is this fixed by a more elaborate than usual
> > a_ops->writepages() ?
> >   
> The second.
> 
> reiser4_writepages() catches the anonymous  (tagged)
> pages, captures them mandatory, then commits all atoms
> of the file.

OK, can you then make it painfully clear in the function comment, esp.
since you export this function?
