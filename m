Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYENWzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYENWzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYENWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:55:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYENWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:55:19 -0400
Date: Wed, 14 May 2008 15:54:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: greg@kroah.com, agruen@suse.de, tiger.yang@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] ext3/4: fix uninitialized bs in
 ext3/4_xattr_set_handle()
Message-Id: <20080514155430.a6b7da8f.akpm@linux-foundation.org>
In-Reply-To: <20080514223003.GJ7054@mit.edu>
References: <4827B878.50903@oracle.com>
	<20080512170254.f79fe869.akpm@linux-foundation.org>
	<4828FD68.40608@oracle.com>
	<200805141256.43272.agruen@suse.de>
	<20080514160035.GD28594@kroah.com>
	<20080514102809.3fc190f0.akpm@linux-foundation.org>
	<20080514223003.GJ7054@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 18:30:03 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, May 14, 2008 at 10:28:09AM -0700, Andrew Morton wrote:
> > 
> > It's in -mm and I just added the "Cc:stable" tag to it.
> 
> This patch has both ext3 and ext4 changes in it, so Andrew, I'm
> assuming that you'll push it directly to Linus in the near future?

Yes, today.

> That's why I didn't suck it into the ext4 tree....

Yup.  Usually I have to split these things up but this time I decided
to leave it as a single patch.  Not sure why, really.
