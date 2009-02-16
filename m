Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZBPUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZBPUF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZBPUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:05:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbZBPUFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:05:50 -0500
Date: Mon, 16 Feb 2009 12:04:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bill Nottingham <notting@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Message-Id: <20090216120434.ce891a32.akpm@linux-foundation.org>
In-Reply-To: <20090216172318.GB26018@nostromo.devel.redhat.com>
References: <1234279525-25143-1-git-send-email-notting@redhat.com>
	<alpine.LNX.1.10.0902111438280.31014@jikos.suse.cz>
	<20090215134144.c29913d9.akpm@linux-foundation.org>
	<20090216172318.GB26018@nostromo.devel.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 12:23:18 -0500 Bill Nottingham <notting@redhat.com> wrote:

> > > Could you please give your Acked-by for it so that I can 
> > > merge, or take it through your tree completely?
> > 
> > afaict this fix is needed all the way back to 2.6.tiny.  I merged it
> > with 2.6.29 intentions.  Also tagged as needed in 2.6.25.x and later.
> 
> So, is there some way to do static analysis on the kernel source to
> find *all* ioctls that aren't marked as compatible, and don't have
> specific compat handlers?

Not that I am aware of.  Julia Lawall might be able to cook up such
a thing.
