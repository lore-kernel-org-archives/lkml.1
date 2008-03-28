Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYC1IxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYC1IxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYC1IxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:53:15 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40044 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYC1IxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:53:14 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080327224231.GA10722@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 27 Mar 2008 22:42:31 +0000)
Subject: Re: [patch 7/7] vfs: mountinfo: show dominating group id
References: <20080327120619.031944658@szeredi.hu> <20080327122400.595798095@szeredi.hu> <20080327224231.GA10722@ZenIV.linux.org.uk>
Message-Id: <E1JfAKB-0000es-4E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Mar 2008 09:52:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 27, 2008 at 01:06:26PM +0100, Miklos Szeredi wrote:
> > +propagate_from:X  mount is slave and receives propagation from peer group X (*)
> >  unbindable  mount is unbindable
> >  
> > +(*) X is the closest dominant peer group under the process's root.  If
> > +X is the immediate master of the mount, or if there's no dominant peer
> > +group under the same root, then only the "master:X" field is present
> > +and not the "propagate_from:X" field.
> 
> Humm...  How does one distinguish between these variants?  Searching
> in mountinfo for vfsmount with group ID of reported master?

Yeah.  We could show propagate_from: unconditionally, but it would be
redundant most of the time.

Miklos
