Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbYBPAuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbYBPAuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYBPAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:49:58 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55903 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYBPAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:49:57 -0500
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
From: Dave Hansen <haveblue@us.ibm.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu, akpm@osdl.org
In-Reply-To: <20080216003219.GA26734@mit.edu>
References: <20080215223721.9E0A088A@kernel>
	 <20080215223730.90A85F4A@kernel>  <20080216003219.GA26734@mit.edu>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 16:49:39 -0800
Message-Id: <1203122979.13230.3.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 19:32 -0500, Theodore Tso wrote:
> On Fri, Feb 15, 2008 at 02:37:30PM -0800, Dave Hansen wrote:
> > 
> > This patch adds two function mnt_want_write() and mnt_drop_write().
> > These are used like a lock pair around and fs operations that might
> > cause a write to the filesystem.
> 
> Argh, is there some reason why this couldn't have gotten merged in
> -rc1, ahead of the rest of the patch series?  This one is going to
> cause more cross-tree merge pain with any filesystem tree that have
> changes to fs/*/ioctl.c.

I wasn't meaning for this to hit the 2.6.25-rc series.  We had some
review comments just when the merge window opened, and I was expecting
them to get stuck back in -mm for another round.

-- Dave

