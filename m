Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXIUSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXIUSrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXIUSrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:47:13 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:59886 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbXIUSrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:47:12 -0400
Date: Fri, 21 Sep 2007 12:47:37 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 4/5] VFS: allow filesystems to implement atomic open+truncate
Message-ID: <20070921184737.GR32520@schatzie.adilger.int>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	akpm@linux-foundation.org, hch@infradead.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123334.643828369@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921123334.643828369@szeredi.hu>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007  14:23 +0200, Miklos Szeredi wrote:
> Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
> initiated by open() due to the O_TRUNC flag".
> 
> This way filesystems wanting to implement truncation within their
> ->open() method can ignore such truncate requests.

This is actually something we've needed to do in Lustre for a while also.
We called it ATTR_FROM_OPEN, but I don't really mind ATTR_OPEN either -
the less patching we need to do the better.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

