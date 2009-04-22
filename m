Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZDVVzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZDVVzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZDVVzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:55:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbZDVVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:55:03 -0400
Date: Wed, 22 Apr 2009 14:52:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: marcin.slusarz@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: add roundup_to_blocksize and bytes_to_blocks helper
 functions
Message-Id: <20090422145255.1e85253e.akpm@linux-foundation.org>
In-Reply-To: <1240436400.7356.39.camel@norville.austin.ibm.com>
References: <49EB7087.70302@gmail.com>
	<20090422141035.efbb1540.akpm@linux-foundation.org>
	<1240436400.7356.39.camel@norville.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 16:40:00 -0500
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Wed, 2009-04-22 at 14:10 -0700, Andrew Morton wrote:
> 
> > roundup_to_blocksize() isn't a terribly good name, IMO.  The name
> > conveys no sense of what the function returns.  It _sounds_ like it
> > returns a "block size".  But it doesn't - it returns a loff_t. 
> > round_up_file_offset_to_block_size() is a bit long though :(
> 
> Is round_up_to_block() any better?  I don't think the trailing "size"
> helps.

dunno.

If the function is documented and if its arg is a loff_t rather than a
bare ull then I guess that makes things sufficiently clear that we
don't have to fuss about its name too much.

