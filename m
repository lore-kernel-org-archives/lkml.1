Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZBCURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZBCURf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZBCURY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:17:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbZBCURW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:17:22 -0500
Date: Tue, 3 Feb 2009 12:17:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
Message-Id: <20090203121706.423d5cab.akpm@linux-foundation.org>
In-Reply-To: <20090203191804.GA24698@elte.hu>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org>
	<498893C8.6080506@oracle.com>
	<20090203191804.GA24698@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 20:18:04 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-02-02-17-12 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > There seems to be some kind of #include hell here.  I moved a few lines
> > around in include/asm-generic/pgtable-nopmd.h & that makes the build
> > get further, but it still has header problems (BUG() is undefined).
> 
> problem caused by which commit?
> 

mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include.patch

This is getting painful.
