Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZFYDYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZFYDYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZFYDYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:24:44 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:57180 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZFYDYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:24:43 -0400
Date: Thu, 25 Jun 2009 06:24:08 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20090625032407.GO6027@tarshish>
References: <20090625111344.35febd82.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090625111344.35febd82.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jun 25, 2009 at 11:13:44AM +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "clk_enable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_disable" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_put" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_get_rate" [drivers/i2c/busses/i2c-designware.ko] undefined!
> ERROR: "clk_get" [drivers/i2c/busses/i2c-designware.ko] undefined!
> 
> Caused by commit 1ab52cf910bbbee92861227e6ed77c56b1dc233c ("i2c: driver
> for the Synopsys DesignWare I2C controller") from Linus' tree which I
> have reverted for today.

So, what is the right configuration symbol to depend on for the clk API?

A short archives search led to the "provide a dummy implementation of the clk 
API" patch from Uwe Kleine-KÃnig 
(http://lkml.indiana.edu/hypermail/linux/kernel/0804.2/2748.html). Is this the 
right solution?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
