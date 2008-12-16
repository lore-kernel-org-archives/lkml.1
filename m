Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYLPSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYLPSWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYLPSWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:22:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbYLPSWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:22:11 -0500
Date: Tue, 16 Dec 2008 10:21:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: mmotm 2008-12-16-00-43 uploaded (fs)
Message-Id: <20081216102136.08ba1714.akpm@linux-foundation.org>
In-Reply-To: <4947ECD8.6050500@oracle.com>
References: <200812160847.mBG8lOrw019428@imap1.linux-foundation.org>
	<4947E856.1040008@oracle.com>
	<4947ECD8.6050500@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 10:00:56 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Randy Dunlap wrote:
> > akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2008-12-16-00-43 has been uploaded to
> >>
> >>    http://userweb.kernel.org/~akpm/mmotm/
> >>
> >> It contains the following patches against 2.6.28-rc8:
> >>
> >> fs-symlink-write_begin-allocation-context-fix.patch
> > 
> > Nick,
> > 
> > fuse and reiser4 still use __grab_cache_page() although your patch
> > removed it:
> > 
> > build-r7257.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/reiser4/plugin/file/file_conversi
> > on.c:689: error: implicit declaration of function '__grab_cache_page'
> > build-r7257.out:make[3]: *** [fs/reiser4/plugin/file/file_conversion.o] Error 1
> > 
> > build-r7248.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/fuse/file.c:792: error: implicit declaration of function '__grab_cache_page'
> > build-r7248.out:make[3]: *** [fs/fuse/file.o] Error 1
> 
> 
> One more related error:
> 
> build-r7258.out:/local/linsrc/tmp/mmotm-2008-1216-0043/fs/ubifs/file.c:251: error: 'flags' undeclared (first use in this function)
> build-r7258.out:make[3]: *** [fs/ubifs/file.o] Error 1

thanks, I dropped it.
