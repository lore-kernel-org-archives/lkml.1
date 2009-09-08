Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZIHRfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZIHRfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZIHRfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:35:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36469 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZIHRfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:35:19 -0400
X-Greylist: delayed 1426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 13:35:19 EDT
Date: Tue, 8 Sep 2009 10:11:32 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, mgreer@mvista.com
Subject: Re: [PATCH 2.6.31-rc9] i2c-mv64xxx.c: correct mv64xxx_i2c_intr()
	return type
Message-ID: <20090908171132.GA28918@mag.az.mvista.com>
References: <200909071000.n87A0CBF019863@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909071000.n87A0CBF019863@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 12:00:13PM +0200, Mikael Pettersson wrote:
> The mv64xxx_i2c_intr() irq handler in drivers/i2c/busses/i2c-mv64xxx.c
> is declared as returning 'int', resulting in this compile-time warning:
> 
> drivers/i2c/busses/i2c-mv64xxx.c: In function 'mv64xxx_i2c_probe':
> drivers/i2c/busses/i2c-mv64xxx.c:540: warning: passing argument 2 of 'request_irq' from incompatible pointer type
> 
> Fix: correct the return type to 'irqreturn_t'.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
