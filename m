Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYAHAON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYAHAON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYAHAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:13:59 -0500
Received: from dns1.vpop.net ([216.193.240.2]:56708 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbYAHAN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:13:58 -0500
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
	settings.
From: Matt Reimer <mreimer@vpop.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Zabel <philipp.zabel@gmail.com>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, szabolcs.gyurko@tlt.hu
In-Reply-To: <20080107151022.82901fcc.akpm@linux-foundation.org>
References: <1199627174.28826.11.camel@localhost.localdomain>
	 <20080107151022.82901fcc.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: VPOP Technologies, Inc
Date: Mon, 07 Jan 2008 16:13:23 -0800
Message-Id: <1199751203.26310.64.camel@bilbo.vpop.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-07 at 15:10 -0800, Andrew Morton wrote:
> On Sun, 06 Jan 2008 14:46:14 +0100
> Philipp Zabel <philipp.zabel@gmail.com> wrote:
> 
> > The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> > high) from IRQ settings. There are devices that have IAS=0 but still need
> > the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> > that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.

> But no drivers are converted to set ds1wm_platform_data.active_high.  Won't
> IORESOURCE_IRQ_HIGHEDGE devices be broken by this change?

Good point; I think you're right. I'd guess the other platforms that use
this driver are in the handhelds.org tree, but I've been out of the loop
a while. Philipp, is this the case?

Matt

