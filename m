Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZDVVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZDVVkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZDVVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:40:04 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50752 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZDVVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:40:01 -0400
Subject: Re: [PATCH] fs: add roundup_to_blocksize and bytes_to_blocks
 helper functions
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090422141035.efbb1540.akpm@linux-foundation.org>
References: <49EB7087.70302@gmail.com>
	 <20090422141035.efbb1540.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 16:40:00 -0500
Message-Id: <1240436400.7356.39.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 14:10 -0700, Andrew Morton wrote:

> roundup_to_blocksize() isn't a terribly good name, IMO.  The name
> conveys no sense of what the function returns.  It _sounds_ like it
> returns a "block size".  But it doesn't - it returns a loff_t. 
> round_up_file_offset_to_block_size() is a bit long though :(

Is round_up_to_block() any better?  I don't think the trailing "size"
helps.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

