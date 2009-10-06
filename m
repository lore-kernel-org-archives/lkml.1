Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZJFPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZJFPTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZJFPTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:19:48 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56779 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696AbZJFPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:19:47 -0400
Date: Tue, 6 Oct 2009 09:19:10 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
       Anand Gadiyar <gadiyar@ti.com>
Subject: Re: [PATCH 2/8] omap: Lock DPLL5 at boot
In-Reply-To: <20091002223859.11962.20369.stgit@localhost>
Message-ID: <alpine.DEB.2.00.0910060918560.7395@utopia.booyaka.com>
References: <20091002223510.11962.21751.stgit@localhost> <20091002223859.11962.20369.stgit@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Tony Lindgren wrote:

> From: Rajendra Nayak <rnayak@ti.com>
> 
> Lock DPLL5 at 120MHz at boot. The USBHOST 120MHz f-clock and
> USBTLL f-clock are the only users of this DPLL, and 120MHz is
> is the only recommended rate for these clocks.
> 
> With this patch, the 60 MHz ULPI clock is generated correctly.
> 
> Tested on an OMAP3430 SDP.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Signed-off-by: Paul Walmsley <paul@pwsan.com>


- Paul
