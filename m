Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbXGLLXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbXGLLXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 07:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbXGLLXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 07:23:10 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4324 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761939AbXGLLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 07:23:08 -0400
Message-ID: <46960F11.8070006@shadowen.org>
Date: Thu, 12 Jul 2007 12:22:57 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cmm@us.ibm.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
In-Reply-To: <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The next version of checkpatch.pl (0.08) should have support for a
number of the missed sylistics you mention.  Will let them soak for a
bit to ensure we're not majorly regressing anything else.

-apw

ERROR: braces {} are not necessary for single statements
#4: FILE: Z11.c:1:
+if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {

WARNING: declaring multiple variables together should be avoided
#9: FILE: Z11.c:6:
+unsigned int total_size, shift_bytes, temp = ~0U;

WARNING: multiple assignments should be avoided
#12: FILE: Z11.c:9:
+is->s.not_found = bs->s.not_found = -ENODATA;

WARNING: kfree(NULL) is safe this check is probabally not required
#16: FILE: Z11.c:13:
+if (bs)
+       kfree(bs);

