Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYCNIms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYCNIms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYCNImg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:42:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40514 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYCNImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:42:35 -0400
To: drepper@redhat.com
CC: viro@ZenIV.linux.org.uk, bharata@linux.vnet.ibm.com,
       libc-alpha@sourceware.org, jblunck@suse.de, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       cmm@us.ibm.com, haveblue@us.ibm.com
In-reply-to: <47DA257C.9060409@redhat.com> (message from Ulrich Drepper on
	Fri, 14 Mar 2008 00:13:00 -0700)
Subject: Re: [RFC] Union mount readdir support in glibc
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com> <20080314053925.GA10722@ZenIV.linux.org.uk> <47DA257C.9060409@redhat.com>
Message-Id: <E1Ja5Tf-0003Op-Fi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Mar 2008 09:41:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Actually, do we really need it other than to 0 and to current position
> > (i.e. full rewind and a no-op)?
> 
> Ever heard of the little function "telldir"?

Actually, telldir/seekdir is already broken for some filesystems (NFS
comes to mind).  POSIX was really crazy to require a working seekdir
implementation, and userspace should quickly start _not_ using it.

The more new filesystems it doesn't work, the better, IMHO.

Miklos
