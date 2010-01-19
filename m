Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123Ab0ASLKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0ASLKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173Ab0ASLKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:10:39 -0500
Received: from mga06.intel.com ([134.134.136.21]:19492 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752141Ab0ASLKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:10:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,302,1262592000"; 
   d="scan'208";a="588376899"
Date: Tue, 19 Jan 2010 12:12:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Use AB3100 MFD core IRQ for interrupt randomness
Message-ID: <20100119111207.GC554@sortiz.org>
References: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
 <1263250075.29868.4750.camel@calx>
 <63386a3d1001171118n6ac88fccx12b7fdfeda204f50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d1001171118n6ac88fccx12b7fdfeda204f50@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sun, Jan 17, 2010 at 08:18:58PM +0100, Linus Walleij wrote:
> 2010/1/11 Matt Mackall <mpm@selenic.com>:
> 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> Sam will you take this patch then?
I had to change the ab3100 Kconfig entry as those random.c symbols are not
exported. The ab3100 driver is now a bool, depending on I2C=y.

Matt, would it make sense to export those symbols ?

Cheers,
Samuel.


> Yours,
> Linus Walleij

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
