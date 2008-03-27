Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbYC0JvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbYC0JvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYC0JvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:51:02 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:48580 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbYC0JvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:51:00 -0400
Date: Thu, 27 Mar 2008 18:50:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080327095034.GA21168@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, hskinnemoen@atmel.com,
	domen.puncer@telargo.com, tony@atomide.com, paul@pwsan.com
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com> <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com> <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com> <20080327091810.GA32396@flint.arm.linux.org.uk> <20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com> <20080327093301.GB32396@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327093301.GB32396@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 09:33:01AM +0000, Russell King wrote:
> On Thu, Mar 27, 2008 at 10:26:48AM +0100, Haavard Skinnemoen wrote:
> > You can extend the struct, put the rate there and use the same
> > getrate() function for all the clocks that need to keep track of the
> > current rate this way.
> 
> Well, if you're really concerned about size, you could do what I did with
> PXA and introduce a struct clk_ops to contain all the constant function
> pointers, rather than mashing the function pointers together - which
> saves far more than trying to combine them.
> 
FWIW, this is also what we've done on SH.
