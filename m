Return-Path: <linux-kernel-owner+w=401wt.eu-S936952AbXGSA7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936952AbXGSA7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761428AbXGSA7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:59:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57680 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408AbXGSA7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:59:20 -0400
Subject: Re: new ext4 build warnings
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jeff Garzik <jeff@garzik.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <469E8822.7000104@garzik.org>
References: <469E8822.7000104@garzik.org>
Content-Type: text/plain; charset=utf-8
Organization: IBM Linux Technology Center
Date: Wed, 18 Jul 2007 17:59:19 -0700
Message-Id: <1184806759.19760.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 17:37 -0400, Jeff Garzik wrote:
> It seems jbd_debug() might need modification:
> 
> fs/ext4/inode.c: In function ‘ext4_write_inode’:
> fs/ext4/inode.c:2906: warning: comparison is always true due to limited 
> range of data type
> 
> fs/jbd2/recovery.c: In function ‘jbd2_journal_recover’:
> fs/jbd2/recovery.c:254: warning: comparison is always true due to 
> limited range of data type
> fs/jbd2/recovery.c:257: warning: comparison is always true due to 
> limited range of data type
> 
> fs/jbd2/recovery.c: In function ‘jbd2_journal_skip_recovery’:
> fs/jbd2/recovery.c:301: warning: comparison is always true due to 
> limited range of data type
> 
> I'm surprised this was not noticed in a test build before pushing upstream.
> 

Hmm,  I am not sure what happened. I get the compile warning on linus
latest git tree, but could not get the same compile warning on Ted's
ext4 git tree. 

In both build CONFIG_JBD2_DEBUG and DEBUG_FS is enabled.

Mingming


