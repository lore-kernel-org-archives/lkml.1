Return-Path: <linux-kernel-owner+w=401wt.eu-S1030376AbXCSQiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376AbXCSQiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXCSQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:38:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42777 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030376AbXCSQiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:38:21 -0400
Date: Mon, 19 Mar 2007 18:38:19 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
In-Reply-To: <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703191836370.22180@sbz-30.cs.Helsinki.FI>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> 
 <45FD8684.4030501@googlemail.com>  <6bffcb0e0703190845s6bdc1a65p71937d1dffbf6d9e@mail.gmail.com>
  <Pine.LNX.4.64.0703191751560.21196@sbz-30.cs.Helsinki.FI>
 <6bffcb0e0703190929rd118b16u21552da0c81b9f04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Michal Piotrowski wrote:
> Yes, revoke-special-mmap-handling.patch is bad.

Aah, the VM_REVOKED flag stomps on VM_CAN_INVALIDATE in -mm. Changing 
VM_REVOKED to 0x10000000 should fix it. I don't have access to kernel tree 
right now so I'll send a patch tomorrow unless someone else beats me to 
it.

				Pekka
