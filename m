Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZEMNDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZEMNDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbZEMNDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:03:24 -0400
Received: from verein.lst.de ([213.95.11.210]:39463 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876AbZEMNDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:03:23 -0400
Date: Wed, 13 May 2009 15:01:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Peter W Morreale <pmorreale@novell.com>, torvalds@osdl.org,
       jens.axboe@oracle.com, akpm@osdl.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: do we really want to export more pdflush details in sysctls
Message-ID: <20090513130128.GA10382@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

commit fafd688e4c0c34da0f3de909881117d374e4c7af titled
"mm: add /proc controls for pdflush threads" adds two more sysctl
variables exposing details about pdflush threads.  At the same time
Jens Axboe is working on the per-bdi writeback patchset which will
hopefull soon get rid of the pdflush threads in their current form.

Is it really a good idea to expose more details now or should we revert
this patch before 2.6.30 is out?

Cheers,
	Christoph
