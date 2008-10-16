Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYJPFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYJPFLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYJPFLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:11:05 -0400
Received: from ozlabs.org ([203.10.76.45]:51460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYJPFLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:11:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 1/2] virtio_net: Recycle some more rx buffer pages
Date: Thu, 16 Oct 2008 16:08:53 +1100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
References: <> <1223494499-18732-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1223494499-18732-1-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161608.54017.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 06:34:58 Mark McLoughlin wrote:
> Each time we re-fill the recv queue with buffers, we allocate
> one too many skbs and free it again when adding fails. We should
> recycle the pages allocated in this case.
>
> A previous version of this patch made trim_pages() trim trailing
> unused pages from skbs with some paged data, but this actually
> caused a barely measurable slowdown.

Yes, I noticed a similar effect.  Not quite sure why though.

Applied.

Thanks!
Rusty.
