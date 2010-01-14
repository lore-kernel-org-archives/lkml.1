Return-Path: <linux-kernel-owner+w=401wt.eu-S932188Ab0ANAZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0ANAZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711Ab0ANAZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:25:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab0ANAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:25:36 -0500
Date: Wed, 13 Jan 2010 16:25:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] procfs: Fix refcnt leak on proc_self_follow_link()
 error path
Message-Id: <20100113162504.1c06c5e6.akpm@linux-foundation.org>
In-Reply-To: <20100113194300.GA4673@ZenIV.linux.org.uk>
References: <87aawkjxlf.fsf@devron.myhome.or.jp>
	<20100113194300.GA4673@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 19:43:01 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Jan 12, 2010 at 03:38:36AM +0900, OGAWA Hirofumi wrote:
> > 
> > If ->follow_link handler return the error, it should decrement
> > nd->path refcnt.
> > 
> > This patch fix it.
> 
> It's OK for -stable, but for the next tree... not really.  I'd rather
> kill vfs_follow_link() uses here and in gfs2; see #untested in vfs-2.6.git
> for details.

Confused.  Is #untested planned for 2.6.33?  If not, how do we fix this
bug in .33?
