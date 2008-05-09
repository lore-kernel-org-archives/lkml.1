Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbYEIMq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbYEIMq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbYEIMoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:44:54 -0400
Received: from tamago.serverit.net ([91.189.209.155]:39597 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763786AbYEIMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:44:52 -0400
Date: Fri, 9 May 2008 15:44:44 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.26 patch] fuse: add flag to turn on big writes
In-Reply-To: <E1JuRk7-0001TW-D2@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.62.0805091541500.15409@tamago.serverit.net>
References: <E1JuRk7-0001TW-D2@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 9 May 2008, Miklos Szeredi wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Prior to 2.6.26 fuse only supported single page write requests.  In
> theory all fuse filesystem should be able support bigger than 4k
> writes, as there's nothing in the API to prevent it.  Unfortunately
> there's a known case in NTFS-3G where big writes cause filesystem
> corruption.  There could also be other filesystems, where the lack of
> testing with big write requests would result in bugs.
> 
> To prevent such problems on a kernel upgrade, disable big writes by
> default, but let filesystems set a flag to turn it on.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Szabolcs Szakacsits <szaka@ntfs-3g.org>

Big thanks Miklos!

Acked-by: Szabolcs Szakacsits <szaka@ntfs-3g.org>

        Szaka

