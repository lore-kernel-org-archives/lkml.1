Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYGPIXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYGPIXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYGPIXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:23:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57109 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYGPIXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:23:37 -0400
Subject: Re: [PATCH 2.6.26] isofs: fix minor filesystem corruption, take 2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Adam Greenblatt <adam.greenblatt@gmail.com>
Cc: akpm@linux-foundation.org, jack@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <487DAEDB.3020007@gmail.com>
References: <487DAEDB.3020007@gmail.com>
Date: Wed, 16 Jul 2008 11:23:23 +0300
Message-Id: <1216196604.6762.57.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On Tue, 2008-07-15 at 22:18 -1000, Adam Greenblatt wrote:
> Some iso9660 images contain files with rockridge data that is either 
> incorrect or
> incompletely parsed.  Prior to commit 
> f2966632a134e865db3c819346a1dc7d96e05309,
> (included with kernel 2.6.13) the kernel ignored the rockridge data for 
> these files,
> while still allowing the files to be accessed under their non-rockridge 
> names.  That
> commit inadvertently changed things so that files with invalid rockridge 
> data could
> not be accessed  at all.  (I ran across the problem when comparing some 
> old CDs with
> hard disk copies I had made long ago under kernel 2.4: a few of the 
> files on the hard
> disk copies were no longer visible on the CDs.)
> 
> This change reverts to the pre-2.6.13 behavior.
> 
> Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
> ---
> Pekka Enberg correctly pointed out that there was a similar change made to
> parse_rock_ridge_inode_internal() that should also be reverted.  Please 
> ignore
> my previous patch, and use this patch instead.  Thanks Pekka!

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

