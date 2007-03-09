Return-Path: <linux-kernel-owner+w=401wt.eu-S1767168AbXCILHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767168AbXCILHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767170AbXCILHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:07:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42923 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767168AbXCILHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:07:10 -0500
Date: Fri, 9 Mar 2007 12:11:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       serue@us.ibm.com
Subject: Re: [PATCH 1/7] revoke: special mmap handling
Message-ID: <20070309121106.606fb0d5@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703091012530.32320@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091012530.32320@sbz-30.cs.Helsinki.FI>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 10:14:09 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This adds special handling for revoked memory mappings.  We want to
> raise SIGBUS when accessing revoked mappings and return ENODEV when
> trying to remap with mmap(2).
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Alan Cox <alan@redhat.com>
