Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYBAWhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYBAWhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757125AbYBAWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:48828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbYBAWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=eq6vuOHjQf7wO1djF3t2ouFKkAno8xT0Ib9WClhiKS6iuD/u7j5w2ONoERpMkYpGGsar1FQ0WR3ZgQuNBUK7q/Rx6fewsIGIcwSh6TDWn161LUC9AJYfN7d35Gp6hDdid+oLZ2afZrznK7hEF2Vd5Mqg8QbWQFr+3iY58EnDi38=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Atari Falcon IDE: Add missing hwif variable
Date: Fri, 1 Feb 2008 22:49:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0801271428390.9257@anakin>
In-Reply-To: <Pine.LNX.4.64.0801271428390.9257@anakin>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802012249.17952.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Geert Uytterhoeven wrote:
> Atari Falcon IDE: Add missing hwif variable
> 
> Commit cbb010c180294a5242a7681555c28737d9dd26ab
> 
>     ide: drop 'initializing' argument from ide_register_hw()
> 
>     * Rename init_hwif_data() to ide_init_port_data() and export it.
>     
>     * For all users of ide_register_hw() with 'initializing' argument set
>       hwif->present and hwif->hold are always zero so convert these host
>       drivers to use ide_find_port()+ide_init_port_data()+ide_init_port_hw()
>       instead (also no need for init_hwif_default() call since the setup
>       done by it gets over-ridden by ide_init_port_hw() call).
>     
>     * Drop 'initializing' argument from ide_register_hw().
>     
> introduced the usage of a hwif variable, but forgot to declare the actual
> variable.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied, thanks
