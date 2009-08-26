Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZHZDg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZHZDg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbZHZDg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:36:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756505AbZHZDg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:36:27 -0400
Date: Tue, 25 Aug 2009 20:36:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090825203623.4798f287.akpm@linux-foundation.org>
In-Reply-To: <20090826121508.a2b8bbcb.kamezawa.hiroyu@jp.fujitsu.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090826121508.a2b8bbcb.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 12:15:08 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 24 Aug 2009 16:28:30 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-08-24-16-24 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> 
> Just FYI. maybe my diff option of quilt is bad..but
> 
> I need to remove this line in linux-next.patch's comment (line 19075)
> 
>     You do not NEED to hold the req_lock since
> ->  107a7ca67f9fffd0c0c94018f5a1f61a0afe7bf8 (2005-03-15).   
>     Since the drbd_pp_lock is not spin_lock_irqsave anymore, you MUST NOT

That's probably patch(1) trying to be clever and failing.

Make sure you're using `patch -u'?
