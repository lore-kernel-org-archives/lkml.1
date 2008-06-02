Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbYFBSOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbYFBSOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYFBSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:14:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:45188 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbYFBSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JrUjqG5RVbUC8QHEj8cZHQP4Qpk86LZrIlZnUl87RADUF+ZhijqUJy8jMTEXPXRemF7Me0RnURMcgViafg2aNTQa1v1UguIFzgnCVJyuUQR1VSB+YhWbSJfue9XdeNq7ZX1ZdUOS2SOOMaXLdloj4reKuIKYxmo/1v6wVU9sv0o=
Message-ID: <86802c440806021114m51ba9148ge69d8ded228d888f@mail.gmail.com>
Date: Mon, 2 Jun 2008 11:14:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: More e820 unification?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48441AFF.3020204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48441AFF.3020204@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 9:08 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Hi,
>
> Are you looking at completely unifying e820_32/64.c?  It looks like the
> delta between them is fairly small.

Yes. but need to wait some pending bugs that is numa32 related get fixed..

next is find_max_pfn and end_of_e820_ram...( memory_present is moved
out of find_max_pfn)...

BTW:
[PATCH] x86: cleanup max_pfn_mapped usage - 32bit
may need you update xen pv to specify max_pfn_mapped early stage...

Thanks

YH
