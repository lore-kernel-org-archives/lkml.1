Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZEEBBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZEEBBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZEEBAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:00:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41390 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZEEBAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ivLiQoSZ81rIz6VDQ49t/FNrRuNtN3yTfCfI884bDbUN+DLk7RHG+2W589lVB4Yoo5
         Ptd6vCUmKzKxO7Aq/wauXSGK2Dep0Dy3Qp/JmGKLxeVghMp3BDDHWiXtBiJpsrkHcuvo
         jBoh1VKwy8+rA1QkTrDjiKZhqrUvU+EqTxGN0=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0905041214160.15574@qirst.com>
References: <20090504163731.3675ea87@rwuerthntp>
	 <alpine.DEB.1.10.0905041214160.15574@qirst.com>
Date: Tue, 5 May 2009 10:00:54 +0900
Message-ID: <44c63dc40905041800j217f11c6yec7fe003fb820419@mail.gmail.com>
Subject: Re: [PATCH] alloc_vmap_area: fix memory leak
From: Minchan Kim <barrioskmc@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ralph Wuerthner <ralphw@linux.vnet.ibm.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice catch!
Looks good to me.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

On Tue, May 5, 2009 at 1:15 AM, Christoph Lameter <cl@linux.com> wrote:
>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Thanks,
Minchan Kim
