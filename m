Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYAGUhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYAGUhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYAGUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:37:10 -0500
Received: from dns2.vpop.net ([216.193.240.3]:2743 "EHLO thorin.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYAGUhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:37:09 -0500
X-Greylist: delayed 1954 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 15:37:09 EST
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
	settings.
From: Matt Reimer <mreimer@vpop.net>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
In-Reply-To: <1199627174.28826.11.camel@localhost.localdomain>
References: <1199627174.28826.11.camel@localhost.localdomain>
Content-Type: text/plain
Organization: VPOP Technologies, Inc
Date: Mon, 07 Jan 2008 12:04:03 -0800
Message-Id: <1199736243.26310.41.camel@bilbo.vpop.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-06 at 14:46 +0100, Philipp Zabel wrote:
> The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> high) from IRQ settings. There are devices that have IAS=0 but still need
> the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>

Looks good to me.

Signed-off-by: Matt Reimer <mreimer@vpop.net>

Matt

