Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYLPQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYLPQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYLPQZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:25:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbYLPQZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:25:46 -0500
Date: Tue, 16 Dec 2008 11:25:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Message-ID: <20081216162541.GB410@bombadil.infradead.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com> <20081216160502.GA15331@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216160502.GA15331@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 04:05:02PM +0000, Ralf Baechle wrote:
> If merge_64() was a standard macro in <asm/compat.h> on all architectures,
> compat_sys_pwrite() could invoke it directly and the need for the compat
> wrapper around the compat wrapper would go away.
> 

+1 for this.

AFAIK, there's issues on s390 and sparc (at least) with sign extension,
that they need to wrap anyway, we should really sort that out in the
generic compat wrappers as well.

cheers, Kyle
