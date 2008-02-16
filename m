Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbYBPAdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbYBPAdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYBPAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:33:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59510 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbYBPAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:33:14 -0500
Date: Fri, 15 Feb 2008 19:32:19 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu, akpm@osdl.org
Subject: Re: [PATCH 07/30] r/o bind mounts: stub functions
Message-ID: <20080216003219.GA26734@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	hch@lst.de, miklos@szeredi.hu, akpm@osdl.org
References: <20080215223721.9E0A088A@kernel> <20080215223730.90A85F4A@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215223730.90A85F4A@kernel>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:37:30PM -0800, Dave Hansen wrote:
> 
> This patch adds two function mnt_want_write() and mnt_drop_write().
> These are used like a lock pair around and fs operations that might
> cause a write to the filesystem.

Argh, is there some reason why this couldn't have gotten merged in
-rc1, ahead of the rest of the patch series?  This one is going to
cause more cross-tree merge pain with any filesystem tree that have
changes to fs/*/ioctl.c.

							- Ted
