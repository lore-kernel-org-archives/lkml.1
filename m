Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbZD1HLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbZD1HLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbZD1HLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:11:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56606 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZD1HLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dHU8Ew6PMX9OtSjIzvexQuzn/nLALNetmyd1Ec8yOobaxSOKlv3C2ZzKBO4xpYjA/r
         0b42oUg54o7dxCK99BynQRjXLVGN2XqgKEAAJlYBbSluVfQKVAMDRBdPysIXRmn72itD
         WXnU/DfOuMX8xSLgXkhbkM9txi1xNMwZZtXqk=
MIME-Version: 1.0
In-Reply-To: <20090428014920.217785938@intel.com>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.217785938@intel.com>
Date: Tue, 28 Apr 2009 10:11:37 +0300
Message-ID: <93e6a6040904280011o25c68e9o672cf2ab64af26cd@mail.gmail.com>
Subject: Re: [PATCH 1/5] pagemap: document clarifications
From: Tommi Rantala <tt.rantala@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/28 Wu Fengguang <fengguang.wu@intel.com>:
> Some bit ranges were inclusive and some not.
> Fix them to be consistently inclusive.
>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/vm/pagemap.txt |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- mm.orig/Documentation/vm/pagemap.txt
> +++ mm/Documentation/vm/pagemap.txt
> @@ -12,9 +12,9 @@ There are three components to pagemap:
>    value for each virtual page, containing the following data (from
>    fs/proc/task_mmu.c, above pagemap_read):
>
> -    * Bits 0-55  page frame number (PFN) if present
> +    * Bits 0-54  page frame number (PFN) if present
>     * Bits 0-4   swap type if swapped
> -    * Bits 5-55  swap offset if swapped
> +    * Bits 5-54  swap offset if swapped
>     * Bits 55-60 page shift (page size = 1<<page shift)
>     * Bit  61    reserved for future use
>     * Bit  62    page swapped

The same fix should be applied to fs/proc/task_mmu.c as well,
it includes the same description of the bits.

Regards,
Tommi Rantala
