Return-Path: <linux-kernel-owner+w=401wt.eu-S934640AbZC0BtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640AbZC0BtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZC0Bs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:48:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9797 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbZC0Bs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fnhsUS09F2Bhct2h8LCGCu7TI0c6107U3mJPTGZbdMQk3McpJUf6xb5FaK8cdled1B
         5nfKclMKRjLeHNEoGYtVCHb67IrXhbNwzcpdRUmK2P3T063TsN+fh+lEqmVCgq6OJ9eq
         aYdrwUrpAbdGevHECHd9az6OoTFNNvodRt1VA=
Date: Fri, 27 Mar 2009 04:56:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Consolidate init_mm definition
Message-ID: <20090327015622.GA8405@x200.localdomain>
References: <20090326235116.GA26129@x200.localdomain> <8bd0f97a0903261705v2a28a9bancbb588c4c7fe365f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0903261705v2a28a9bancbb588c4c7fe365f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 08:05:05PM -0400, Mike Frysinger wrote:
> On Thu, Mar 26, 2009 at 19:51, Alexey Dobriyan wrote:
> > +++ b/mm/init-mm.c
> > @@ -0,0 +1,13 @@
> > +#include <linux/mm_types.h>
> > +#include <asm/pgtable.h>
> 
> shouldnt there be a short license blurb ?
> /* Licensed under the GPL-2 or later. */
> -mike

Why should it be? Even more, kernel is under GNU GPL 2, not "or later".
