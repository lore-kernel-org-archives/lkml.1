Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYK0QaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYK0QaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0Q3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:29:53 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:25846 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0Q3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:29:52 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 7/8] fsnotify: add in inode fsnotify markings
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 17:29:45 +0100
Message-Id: <1227803385.4454.1780.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> +/*
> + * add (we use |=) the mark to the in core inode mark
> + *
> + * THIS FUNCTION RETURNS HOLDING THE INODE LOCK!!!
> + */

YUCK, BUT I GUESS VFS PEOPLE WILL HAVE TO VALIDATE ITS MERRIT.

