Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXEGMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXEGMkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXEGMkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:40:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:46842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbXEGMk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EMuKhDR2U7hdITRMtxB/Oej5BaFNrGc5hvurNCbd0H9fYPUePT20nmMki3NBZJPq657HruCk61mcjc92u/jpzZQ8RuphVoJtrLKhzBQT/CvM4E+FcNF5nfiW9ei7sZh0QH9smIIL1eDa9egvH4kK/9Z+4XVOjfUOcHV5JVm02qg=
Message-ID: <84144f020705070540tf3b1986yd4b1ab65e3a17d5e@mail.gmail.com>
Date: Mon, 7 May 2007 15:40:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] ext4: write support for preallocated blocks/extents
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
In-Reply-To: <20070426181623.GE7209@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426181623.GE7209@amitarora.in.ibm.com>
X-Google-Sender-Auth: 7ffddca7cb123766
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Amit K. Arora <aarora@linux.vnet.ibm.com> wrote:
>  /*
> + * ext4_ext_try_to_merge:
> + * tries to merge the "ex" extent to the next extent in the tree.
> + * It always tries to merge towards right. If you want to merge towards
> + * left, pass "ex - 1" as argument instead of "ex".
> + * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
> + * 1 if they got merged.
> + */
> +int ext4_ext_try_to_merge(struct inode *inode,
> +                               struct ext4_ext_path *path,
> +                               struct ext4_extent *ex)
> +{

Please either use proper kerneldoc format or drop
"ext4_ext_try_to_merge" from the comment.
