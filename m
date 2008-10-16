Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYJPJNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYJPJNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYJPJMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:12:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36054 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbYJPJMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:12:44 -0400
Message-ID: <48F70586.10607@garzik.org>
Date: Thu, 16 Oct 2008 05:12:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>,
       NetDev <netdev@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3 of 5] xen-netfront: Avoid unaligned accesses to IP	header
References: <d3d2ad0d95db689f77ab.1224031842@abulafia.goop.org>
In-Reply-To: <d3d2ad0d95db689f77ab.1224031842@abulafia.goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Isaku Yamahata <yamahata@valinux.co.jp>
> 
> Align ip header to a 16 byte boundary to avoid unaligned
> access like other drivers.
> Without this patch, xen-netfront doesn't work well on ia64.
> 
> [ Jeff, this is the only patch in the series which is in your
>   territory. -J ]
> 
> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/net/xen-netfront.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

applied


