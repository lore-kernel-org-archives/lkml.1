Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYC0Jkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYC0Jkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYC0Jkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:40:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33576 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYC0Jkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:40:35 -0400
Date: Thu, 27 Mar 2008 09:36:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080327093611.GC32396@flint.arm.linux.org.uk>
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com> <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com> <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com> <20080327091810.GA32396@flint.arm.linux.org.uk> <74d0deb30803270229h1244c5bfr5ca521dbb87b0583@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30803270229h1244c5bfr5ca521dbb87b0583@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:29:27AM +0100, pHilipp Zabel wrote:
> >  The result for PXA is a tradeoff between reducing the data size and
> >  increasing the text size, or increasing the data size and keeping
> >  the existing data size.
> 
> Wouldn't something like the above work without increasing text size too much?

It still increases the overall size dramatically since all these function
pointers are replicated for each clock (which I've pointed to an existing
solution for).

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
