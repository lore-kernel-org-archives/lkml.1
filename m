Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbYBZUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbYBZUdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbYBZUc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:32:56 -0500
Received: from mail.vyatta.com ([216.93.170.194]:35107 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765028AbYBZUcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:32:54 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.885
Date: Tue, 26 Feb 2008 12:32:47 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: romieu@fr.zoreil.com, sorbica@icplus.com.tw, jesse@icplus.com.tw,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
Message-ID: <20080226123247.2b63bbf0@extreme>
In-Reply-To: <Pine.LNX.4.64.0802262148270.12999@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0802262148270.12999@sbz-30.cs.Helsinki.FI>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Convert the internal JUMBO_FRAME #ifdef to CONFIG_IP1000_JUMBO_FRAME proper and
> fix compilation errors.
> 
> Cc: Francois Romieu <romieu@fr.zoreil.com>
> Cc: Sorbica Shieh <sorbica@icplus.com.tw>
> Cc: Jesse Huang <jesse@icplus.com.tw>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Please don't do this as a config option. Config options seem like a good idea
to developers but are difficult for distributions.  Either support jumbo
frames by default or not at all.
