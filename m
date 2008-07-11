Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbYGKTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbYGKTYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbYGKTVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:21:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760412AbYGKTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:21:42 -0400
Date: Fri, 11 Jul 2008 12:20:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a const assignment in moxa_load_fw()
Message-Id: <20080711122056.8b36c084.akpm@linux-foundation.org>
In-Reply-To: <20080708171029.08db0f4d@the-village.bc.nu>
References: <20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
	<20080708171029.08db0f4d@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 17:10:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 08 Jul 2008 16:44:16 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Fix an assignment of a const pointer to a non-const pointer in moxa_load_fw().
> > 
> > This was introduced by patch 037182346f0991683cc7320a257c3f6089432cee.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Acked-by: Alan Cox <alan@redhat.com>

Appears to already be fixed in linux-next, perhaps by this:

commit b30a6a47716ba1a5112b44f0a3962daff961935e
Author: Alan Cox <alan@redhat.com>
Date:   Fri Jul 4 19:18:14 2008 +1000

    83-tty-moxa-warning
    
    Signed-off-by: Alan Cox <alan@redhat.com>

which, err, isn't in today's linux-next because the whole tty tree got
accidentally dropped.  Not that this was a tty patch.

Hopefully the patches in this tree will get title and changelog repairs
before they go much further.  I suspect a lot of this damage was due to
incompatibility between Alan's patch-file format and the expectations of
Stephen's scripts.
