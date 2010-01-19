Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054Ab0ASTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0ASTCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320Ab0ASTCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:02:37 -0500
Received: from waste.org ([173.11.57.241]:38936 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0ASTCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:02:36 -0500
Subject: Re: [PATCH] Use AB3100 MFD core IRQ for interrupt randomness
From: Matt Mackall <mpm@selenic.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
In-Reply-To: <20100119111207.GC554@sortiz.org>
References: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
	 <1263250075.29868.4750.camel@calx>
	 <63386a3d1001171118n6ac88fccx12b7fdfeda204f50@mail.gmail.com>
	 <20100119111207.GC554@sortiz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 13:02:29 -0600
Message-ID: <1263927749.29868.6381.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 12:12 +0100, Samuel Ortiz wrote:
> Hi Linus,
> 
> On Sun, Jan 17, 2010 at 08:18:58PM +0100, Linus Walleij wrote:
> > 2010/1/11 Matt Mackall <mpm@selenic.com>:
> > 
> > > Acked-by: Matt Mackall <mpm@selenic.com>
> > 
> > Sam will you take this patch then?
> I had to change the ab3100 Kconfig entry as those random.c symbols are not
> exported. The ab3100 driver is now a bool, depending on I2C=y.
> 
> Matt, would it make sense to export those symbols ?

Let's not for now, I plan to change this API.

-- 
http://selenic.com : development and support for Mercurial and Linux


