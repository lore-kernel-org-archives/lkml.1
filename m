Return-Path: <linux-kernel-owner+w=401wt.eu-S938309AbXHIBGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938309AbXHIBGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXHIBF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:05:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:1571 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763132AbXHIBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QSX2hDZZbOdJme2O8UJJ/bGT+Z1hGFCWZ00Q4n0pAv3GR/1aAcuoHH9hlenGepIUgXngqYunMj5REK+nC4wMDVcbPLQhRfRdXgiu2d0DRmkhGseVboF3VMI3U+zMw4vFfF4KvB5cDxttX0PAcV/o0/A3yFTUMY8hgCTRfXZ6/Fo=
Message-ID: <5d6222a80708081805t633455cr381f9b4d687c73fb@mail.gmail.com>
Date: Wed, 8 Aug 2007 22:05:53 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 5/7] Change lguest launcher to use asm generic include
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Jes Sorensen" <jes@sgi.com>, "Carsten Otte" <cotte@de.ibm.com>
In-Reply-To: <20070809003343.829371800@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809003211.373543702@goodmis.org>
	 <20070809003343.829371800@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/Documentation/lguest/lguest.c
> +++ b/Documentation/lguest/lguest.c
> @@ -46,7 +46,7 @@ typedef uint32_t u32;
>  typedef uint16_t u16;
>  typedef uint8_t u8;
>  #include "../../include/linux/lguest_launcher.h"
> -#include "../../include/asm-i386/e820.h"
> +#include "../../include/asm/e820.h"

Couldn't we add the ../../../../../../../etc to the Makefile and avoid it here?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
