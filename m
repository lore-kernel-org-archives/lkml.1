Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXIMXGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXIMXGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXIMXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:06:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbXIMXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:06:23 -0400
Date: Thu, 13 Sep 2007 16:05:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.23-rc4-mm1: git-block.patch broke pktcdvd
Message-Id: <20070913160554.ba812d76.akpm@linux-foundation.org>
In-Reply-To: <46E9BEB1.3060504@free.fr>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	<46E5A6D1.3050704@free.fr>
	<46E9BEB1.3060504@free.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007 00:50:25 +0200
Laurent Riffard <laurent.riffard@free.fr> wrote:

> I dig through git-block.patch and the culprit seems to be commit
> c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
> bio_init()".

I think I'll be dropping git-block.  There were a number of problems
in rc4-mm1 (for which I have a sprinkling of messy-looking patches
somewhere ahead of my current cursor) and nothing seems to have
happened in the git tree for a month or so.
