Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXEaKsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXEaKsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXEaKsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:48:24 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6215 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671AbXEaKsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:48:23 -0400
Date: Thu, 31 May 2007 12:47:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531104722.GP32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531103316.GO32105@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Jens Axboe wrote:
> Hi,
> 
> This patch removes the ->sendfile() hook from the file_operations
> structure, and replaces the sys_sendfile() mechanism to be based on
> ->splice_read() instead. There should be no functional changes.

Forgot to mention, that the modified kernel of course passes ltp
sendfile tests. FWIW.

-- 
Jens Axboe

