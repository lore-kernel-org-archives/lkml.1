Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbYBVJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbYBVJGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYBVJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:05:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51103 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752889AbYBVJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:05:22 -0500
Date: Fri, 22 Feb 2008 10:05:09 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] macb: Fix speed setting
Message-ID: <20080222100509.13157a97@dhcp-252-066.norway.atmel.com>
In-Reply-To: <1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
	<1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 17:41:05 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
> conversion to generic PHY layer in kernel 2.6.23.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---

Btw, in case it wasn't clear, I want this to go into your "fixes" queue
and merged before 2.6.25 since it fixes a bug that prevents the driver
from working on 10Mbps networks. I'll send the patch to the stable team
after it hits mainline.

Thanks!

Haavard
