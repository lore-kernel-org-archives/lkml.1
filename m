Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbXEJM44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbXEJM44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXEJM4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:56:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:59648 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbXEJM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tsDLk5MRQYvPTeVTXnG9+m7YrI2Lz8Xxm+rk/93eNzW7zFmXKwzjyQRWOeWATkKsonDNxlW7P26vqEIO4ea01pxC9BRYaOmKRV6YE4dziKPPanY1d+VXeqeBCyaJIBE8tTP93lh099oEcIw8M1dV4HHhhNsuB+uV48LPeeW8YpE=
Message-ID: <84144f020705100556x2fd70556p37cde356520e515d@mail.gmail.com>
Date: Thu, 10 May 2007 15:56:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] ext2: remove inode constructor
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, adilger@clusterfs.com,
       clameter@sgi.com
In-Reply-To: <20070509133948.814128f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI>
	 <20070509133948.814128f4.akpm@linux-foundation.org>
X-Google-Sender-Auth: a11434423b7121b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> ext2 has no truncate_mutex.

I think it does:

-               mutex_init(&ei->truncate_mutex);
-               inode_init_once(&ei->vfs_inode);
-       }
-}

And fs/ext2/super.c:init_once() from 2.6.21-mm2 says:

                mutex_init(&ei->truncate_mutex);
                inode_init_once(&ei->vfs_inode);
        }
}

Hmm?

On 5/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> These patches are rather tangled up with the unmerged __GFP_RECLAIMABLE
> stuff.  I'll duck them for now.

Ok. I would appreciate any kind of heads-up when you're ready to eat
these patches again. ;-)
