Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbXC1XVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbXC1XVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933834AbXC1XVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:21:08 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:44448 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837AbXC1XVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:21:07 -0400
In-Reply-To: <20070328161420.3c8f9688.akpm@linux-foundation.org>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com> <20070322170122.ee2589a1.akpm@linux-foundation.org> <b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com> <20070326201552.b8ad7dda.akpm@linux-foundation.org> <b040c32a0703271047vba81938q538d182c9c984f42@mail.gmail.com> <3D4D126C-0B26-4B00-A2E4-68BD84555B51@oracle.com> <20070328161420.3c8f9688.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3F0B1567-B32C-44F4-9B90-0737ADDACC56@oracle.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Date: Wed, 28 Mar 2007 16:21:04 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does this look OK?

Almost...

> #ifdef CONFIG_HIGHMEM
> static inline void pipe_kunmap_atomic(void *addr, enum km_type type)
> #else	/* CONFIG_HIGHMEM */
> static inline void pipe_kunmap_atomic(struct page *page, enum  
> km_type type)

- z
