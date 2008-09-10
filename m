Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYIJQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYIJQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYIJQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:25:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:15416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYIJQZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,373,1217833200"; 
   d="scan'208";a="334918888"
Message-ID: <48C7F4EC.1080709@intel.com>
Date: Wed, 10 Sep 2008 09:25:16 -0700
From: Chris Leech <christopher.leech@intel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>,
       jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, devel@open-fcoe.org
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for	accessing	3-byte
 arrays as integers
References: <20080905165732.16689.50256.stgit@localhost.localdomain>	 <20080910140712.GA12280@infradead.org> <1221061241.27385.14.camel@norville.austin.ibm.com>
In-Reply-To: <1221061241.27385.14.camel@norville.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp wrote:
> On Wed, 2008-09-10 at 10:07 -0400, Christoph Hellwig wrote:
> 
>> JFS already defines an __le24, see fs/jfs/endian24.h.  Please try to
>> cover it, too or at least make sure you don't break it.
> 
> Chris,
> This patch takes care of jfs.  Please add it to your patchset.
> 
> Thanks,
> Shaggy

Thanks, I was just about to look into JFS.

> @@ -62,7 +60,7 @@ struct timestruc_t {
>   */
>  typedef struct {
>  	unsigned len:24;
> -	unsigned off1:8;
> +	u8 off1;
>  	u32 off2;
>  } lxd_t;

Shouldn't len here be changed to a __le24?  I think this just changed
the size of lxd_t by a byte.

- Chris
