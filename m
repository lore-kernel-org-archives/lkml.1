Return-Path: <linux-kernel-owner+w=401wt.eu-S936835AbXHIA4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936835AbXHIA4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765581AbXHIA4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:56:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:59403 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763828AbXHIA4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kL8FEwpA1g1FwYNESFyLexLCNfaTq8ZGcPZRttlhgszI3RfgUeXLzbyvpAr+aPlxaBjOnTWjWXljytzg7KZNbHvztHxbQ0tM8P2sBRE/p2zy+MtNIcans9zWh8lrUsvWYdiZT6QxlpTz8a9BgUp5mB3QgsiXtt+v6FG41gOhUJ8=
Message-ID: <5d6222a80708081756r21bbc7e3ifd357c9c548ac57f@mail.gmail.com>
Date: Wed, 8 Aug 2007 21:56:37 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/7] Added generic lg.h in lguest directory.
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Jes Sorensen" <jes@sgi.com>, "Carsten Otte" <cotte@de.ibm.com>
In-Reply-To: <20070809003343.310187242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809003211.373543702@goodmis.org>
	 <20070809003343.310187242@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> Add a generic lg.h file to call the architecture specific one.
>
> diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
> new file mode 100644
> index 0000000..4c4356e
> --- /dev/null
> +++ b/drivers/lguest/lg.h
> @@ -0,0 +1,3 @@
> +#ifdef CONFIG_X86_32
> +#include "i386/lg.h"
> +#endif

Wouldn't it be cleaner to do something like the asm/ includes?
I understand that lguest now lives in drivers/ and so we don't put
headers directly in asm-i386 , but we could come up with a similar
thing here.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
