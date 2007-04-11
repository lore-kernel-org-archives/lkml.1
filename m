Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXDKTf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXDKTf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030188AbXDKTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:35:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63519 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030187AbXDKTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:35:56 -0400
Date: Wed, 11 Apr 2007 12:34:33 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Chen <kenchen@google.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411193433.GB9602@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <20070411121146.47ca5b4d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411121146.47ca5b4d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ken uses the other (superior!) way of implementing ringbuffers: the head
> and tail pointers (the naming of which AIO appears to have reversed) are
> not constrained to the ringsize - they are simply allowed to wrap through
> 0xfffffff.

A-ha!  That sure sounds great.

I'd be happy to see the kernel side fs/aio.c ring management move in
that direction, sure, with a specific patch to do that.

I get less excited when we talk about changing the index semantics as
part of supporting serialization of the ring with userspace.

- z
