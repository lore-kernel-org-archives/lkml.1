Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZLDKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZLDKy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZLDKy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:54:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbZLDKy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:54:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
References: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       akpm@linux-foundation.org, gyang@blackfin.uclinux.org,
       john.johansen@canonical.com
Subject: Re: [PATCH] security: do not check mmap_min_addr on nommu systems
Date: Fri, 04 Dec 2009 10:52:24 +0000
Message-ID: <32275.1259923944@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> +/* sec_flags for security_file_mmap */
> +/* Only check the address portion */
> +#define SECURITY_MMAP_ADDR_ONLY	0x01
> +/* Do not do the address checks */
> +#define SECURITY_MMAP_NOT_ADDR	0x02

I'm still not happy with the names assigned to these constants.  

Can we call them:

#define SECURITY_MMAP_ADDR_CHECK_ONLY	0x01
#define SECURITY_MMAP_SKIP_ADDR_CHECK	0x02

and then discard the comments?

Also, the big banner comment in security.h that describes all the function
pointers does not make any mention of this argument.  Can you fix that too,
please?

David
