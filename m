Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYIILUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYIILUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYIILUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:20:35 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46405 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYIILUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=q41yChWU5fINAPaOUxmVAWlpH6HvjvSj1H6fTBAUHzkq3O9A8xr5MDfrEsQkdLrmGW
         CwvpRxjzjRJlw43inTFZL8qzi9+Ztdl2XnieazVFCc5q6eet8bCM0Gse8p9KNA+qN782
         cne4bIka+Iyx9ZFllv5drtf0mDPEJJsPFQPQw=
Message-ID: <2f11576a0809090420u67e15e32ta8e4a523c369f27b@mail.gmail.com>
Date: Tue, 9 Sep 2008 20:20:32 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Hugh Dickins" <hugh@veritas.com>,
       "William Irwin" <wli@holomorphy.com>, "Adam Litke" <agl@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, roland@redhat.com,
       sugita <yumiko.sugita.yf@hitachi.com>,
       "Satoshi OSHIMA" <satoshi.oshima.fk@hitachi.com>
In-Reply-To: <48C48520.9070206@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080902134850.GA26372@csn.ul.ie> <48C48520.9070206@hitachi.com>
X-Google-Sender-Auth: b7ab1dd6ab3ee6f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it was just forgotten to be updated.  Bit 4 was introduced
> by Roland McGrath, and it means elf header pages in file-backed
> private VMAs are dumped even if bit 2 is cleared.
>
> Thanks,
>
>
> Subject: [PATCH] coredump_filter: add description of bit 4
>
> There is no description of bit 4 of coredump_filter in the
> documentation.  This patch adds it.
>
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> CC: Roland McGrath <roland@redhat.com>
> ---
>  Documentation/filesystems/proc.txt |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-2.6.27-rc5/Documentation/filesystems/proc.txt
> ===================================================================
> --- linux-2.6.27-rc5.orig/Documentation/filesystems/proc.txt
> +++ linux-2.6.27-rc5/Documentation/filesystems/proc.txt
> @@ -2394,6 +2394,8 @@ The following 4 memory types are support
>   - (bit 1) anonymous shared memory
>   - (bit 2) file-backed private memory
>   - (bit 3) file-backed shared memory
> +  - (bit 4) ELF header pages in file-backed private memory areas (it is
> +            effective only if the bit 2 is cleared)
>
>   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
>   are always dumped regardless of the bitmask status.

Very thanks, kawai-san.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
