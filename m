Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZC0AFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZC0AFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZC0AFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:05:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:42833 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbZC0AFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gs+99/2Wk7ICN4R795K6fVcOFgxjtwk0A4sjNG3F3+9j0W9bwqxuTcy+mWfoCJOJ0L
         1Eo9BlWfa+42jI38vKn1p9gTIjTy7oZ5VWi33jAM464oojMchIe0RJxXQfJgIWFC1jSZ
         OportY3/QjutQ1JzwglMIbLOkNH9pzbSRuLrk=
MIME-Version: 1.0
In-Reply-To: <20090326235116.GA26129@x200.localdomain>
References: <20090326235116.GA26129@x200.localdomain>
Date: Thu, 26 Mar 2009 20:05:05 -0400
Message-ID: <8bd0f97a0903261705v2a28a9bancbb588c4c7fe365f@mail.gmail.com>
Subject: Re: [PATCH] Consolidate init_mm definition
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 19:51, Alexey Dobriyan wrote:
> new file mode 100644
> --- /dev/null
> +++ b/mm/init-mm.c
> @@ -0,0 +1,13 @@
> +#include <linux/mm_types.h>
> +#include <asm/pgtable.h>

shouldnt there be a short license blurb ?
/* Licensed under the GPL-2 or later. */
-mike
