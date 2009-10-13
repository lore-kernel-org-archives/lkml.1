Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbZJMHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbZJMHSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbZJMHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:18:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38652 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbZJMHSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:18:13 -0400
Date: Tue, 13 Oct 2009 09:17:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mikem@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: Fix multiple calls to pci_release_regions
Message-ID: <20091013071736.GN9228@kernel.dk>
References: <20091012153427.4315.49876.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012153427.4315.49876.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12 2009, Stephen M. Cameron wrote:
> Fix multiple calls to pci_release_regions.  If cciss_pci_init
> fails, it already does any necessary call to pci_release_regions,
> so this does not need to be done again in cciss_init_one in that
> case.

Thanks, applied

-- 
Jens Axboe

