Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbYAGPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbYAGPl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYAGPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:41:52 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48389 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbYAGPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:41:51 -0500
Date: Mon, 7 Jan 2008 18:41:02 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Reimer <mreimer@vpop.net>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state settings.
Message-ID: <20080107154101.GB7806@2ka.mipt.ru>
References: <1199627174.28826.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199627174.28826.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Jan 06, 2008 at 02:46:14PM +0100, Philipp Zabel (philipp.zabel@gmail.com) wrote:
> The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> high) from IRQ settings. There are devices that have IAS=0 but still need
> the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

I have no problem with this patch, thank you.

Andrew, please apply.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


-- 
	Evgeniy Polyakov
