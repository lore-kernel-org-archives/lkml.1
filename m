Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYDCVuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYDCVuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbYDCVuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:50:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:59171 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbYDCVuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=MVfBiWXGKM4v+dxuVscGkHlkxIUNd9iI8MWHoBeR4EQkcUt9pfvx/3nNh2miiAyImIGLZU/tJxJUHMdoJt06k/dpX+6rbEFa11ygqcz6JKvKKFCdeRW3nYn6Rc52NKcMaIbMsSrRWtlVCnyorhrbTC7abI5tNCcLozN6nu/yRdM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/5] ide-tape: improve buffer allocation strategy
Date: Thu, 3 Apr 2008 23:32:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com> <1206812769-10065-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1206812769-10065-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804032332.29380.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 29 March 2008, Borislav Petkov wrote:
> Instead of allocating pages for the buffer one by one, take advantage of the
> buddy alloc system and request them 2^order at a time. This increases the chance
> for bigger buffer parts to be contigious and reduces loop iteration count. While
> at it, rename function __idetape_kmalloc_stage() to ide_tape_kmalloc_buffer().
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied patches #1-4
