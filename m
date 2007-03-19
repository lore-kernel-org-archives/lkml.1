Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXCSPyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXCSPyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXCSPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:54:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33791 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXCSPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:54:06 -0400
Date: Mon, 19 Mar 2007 17:54:04 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
In-Reply-To: <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> 
 <45FD8684.4030501@googlemail.com> <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micael,

On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> Pekka, can you take a look at this problem and fix my initrd? :)
> 
> GOOD
> #
> revoke-special-mmap-handling.patch
> revoke-core-code.patch
> revoke-core-code-misc-fixes.patch
> revoke-core-code-fix-shared-mapping-revoke.patch
> revoke-core-code-move-magic.patch
> revoke-support-for-ext2-and-ext3.patch
> revoke-add-documentation.patch
> revoke-wire-up-i386-system-calls.patch
> BAD

Oh, sorry about that. Can you confirm that the patch
revoke-special-mmap-handling.patch is bad? If it's not, then it must be 
the late_initcall for revokefs_init that's causing the trouble. Hmm..

			Pekka
