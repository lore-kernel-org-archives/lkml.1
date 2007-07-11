Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbXGKMEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbXGKMEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbXGKMDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:03:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbXGKMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:03:49 -0400
Date: Wed, 11 Jul 2007 13:03:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 5/5] i_version: noversion mount option to disable inode version updates
Message-ID: <20070711120346.GB26370@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1183275474.4010.132.camel@localhost.localdomain> <20070710163144.21b739f9.akpm@linux-foundation.org> <20070711115716.GU6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711115716.GU6417@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:57:17AM -0600, Andreas Dilger wrote:
> Ah, this is the patch to disable i_version updates for Lustre.  I don't
> think any normal user would use this mount option, so I don't know if
> there is a need to document it.

This is a reason to not merge it at all.  If the only user of this is
the out of tree lustre code there is no need to put this in.  I should
rather stay in clusterfs' patchkit.

