Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYA3CIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYA3CIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA3CIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:08:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbYA3CIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:08:42 -0500
Date: Tue, 29 Jan 2008 18:08:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: raise max number of nbd devices to 1024
Message-Id: <20080129180857.f8979300.akpm@linux-foundation.org>
In-Reply-To: <479FDB15.4090104@steeleye.com>
References: <479F9B12.8010207@steeleye.com>
	<20080129135417.e20b8107.akpm@linux-foundation.org>
	<479FDB15.4090104@steeleye.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 21:04:05 -0500 Paul Clements <paul.clements@steeleye.com> wrote:

> Andrew Morton wrote:
> 
> <snip>
> 
> > much nicer?
> 
> OK, yes, I was going for quick and easy, but you've got a point...
> 
> We do need to move the kcalloc into nbd_init instead of nbd_cleanup, 
> though -- that works a little better. Patch is attached. Thanks for the 
> suggestion.
> 
> --
> Paul
> 
> 
> [nbd_max_nbd_killed.diff  text/x-patch (1.2KB)]
> 
> Signed-Off-By: Paul Clements <paul.clements@steeleye.com>
> 
> --- ./include/linux/nbd.h.TIMEOUT	2007-08-22 13:18:12.000000000 -0400
> +++ ./include/linux/nbd.h	2008-01-29 20:01:33.000000000 -0500

Could we have a complete changelog please?  As I mentioned in the
earlier email?
