Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYIVTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYIVTvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYIVTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:51:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYIVTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:51:08 -0400
Date: Mon, 22 Sep 2008 12:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: mmotm 2008-09-22-01-36 uploaded (profiling)
Message-Id: <20080922125018.e12adb8b.akpm@linux-foundation.org>
In-Reply-To: <20080922111956.fd6dcb20.randy.dunlap@oracle.com>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
	<20080922111956.fd6dcb20.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 11:19:56 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc7:
> 
> kernel/built-in.o: In function `profiling_store':
> ksysfs.c:(.text+0x1b9b1): undefined reference to `create_proc_profile'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> 
> when CONFIG_PROC_FS=n.
> 

That'll be Dave's profiling-dynamically-enable-readprofile-at-runtime.patch
