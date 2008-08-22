Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYHVDGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYHVDGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYHVDFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:05:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:54039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYHVDFs (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k+F3sPszGbyS/b43XBnp/zGapUqtTbihraF/d5wGDPfEJrBr67PxJfANZCwvTqpT8E
         m7ZytG7TLERWFukbuWHh23cP50S3fNxC+LZSvc78dhDgnK+5CaRU/Wm0R0LwRNRK5MOa
         vtX6Do8b2J+SCP/Dit0+1cug54XmRBC5cxzIg=
Message-ID: <6934efce0808212005h30fa16d8w48833e8a0becfd8c@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:05:48 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AE19AD.1020209@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD0101.4020505@gmail.com> <48AE19AD.1020209@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From this it would appear that if the region data can't be mapped XIP (i.e.
> it is compressed or on a block device), it is cached in its entirety in RAM?

That is correct.

> This implies for block devices that the entire filesystem metadata has to be
> cached in RAM.  This severely limits the size of AXFS filesystems when using
> block devices, or the else memory usage will be excessive.

This is where 64bit squashfs could be a better fit.
