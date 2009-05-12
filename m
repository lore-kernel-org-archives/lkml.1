Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZELWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZELWQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbZELWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:15:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbZELWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:15:44 -0400
Date: Tue, 12 May 2009 15:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Yang <leoli@freescale.com>
Cc: galak@kernel.crashing.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: [PATCH 5/6] rio: warn_unused_result warnings fix
Message-Id: <20090512151112.7e2a3e74.akpm@linux-foundation.org>
In-Reply-To: <1242117363-14949-5-git-send-email-leoli@freescale.com>
References: <1242117363-14949-1-git-send-email-leoli@freescale.com>
	<1242117363-14949-2-git-send-email-leoli@freescale.com>
	<1242117363-14949-3-git-send-email-leoli@freescale.com>
	<1242117363-14949-4-git-send-email-leoli@freescale.com>
	<1242117363-14949-5-git-send-email-leoli@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 16:36:02 +0800
Li Yang <leoli@freescale.com> wrote:

> +	if (rswitch) {
> +		if (rswitch->route_table)

this `if' is unneeded.

> +			kfree(rswitch->route_table);
> +		kfree(rswitch);
> +	}
