Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXEAC0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXEAC0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXEAC0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:26:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbXEAC0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:26:02 -0400
Date: Mon, 30 Apr 2007 19:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neela Kolli <Neela.Kolli@engenio.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] megaraid: fix CONFIG_PROC_FS compile errors
Message-Id: <20070430192544.5ee78178.akpm@linux-foundation.org>
In-Reply-To: <20070430084414.be98e552.randy.dunlap@oracle.com>
References: <Pine.LNX.4.64.0704291658140.1822@chino.kir.corp.google.com>
	<20070430084414.be98e552.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 08:44:14 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 30 Apr 2007 07:35:00 -0700 (PDT) David Rientjes wrote:
> 
> > Only declare mega_proc_dir_entry() in CONFIG_PROC_FS.  We should call
> > mega_create_proc_entry() only in this configuration so make sure it's defined
> > if we call it.
> > 
> > Only define mega_adapinq() in CONFIG_PROC_FS.  mega_internal_dev_inquiry()
> > and mega_print_inquiry() were never declared without CONFIG_PROC_FS so
> > make sure we don't have prototypes for them if we aren't going to define
> > them.
> > 
> > Move the declaration of 'buf' in mega_remove_one() because we only use it
> > in the CONFIG_PROC_FS case.
> 
> Just noting the presence of:
>   http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/megaraid-fix-warnings-when-config_proc_fs=n.patch
> 

That patch has been submitted fourteen times in the past year, and was
completely ignored each time.

> 
> Oh, and that SCSI patches need to go to the linux-scsi mailing list.
> 

There seem to be little point in doing that.
