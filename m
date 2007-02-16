Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbXBPBN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbXBPBN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXBPBN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:13:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbXBPBN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:13:57 -0500
Date: Thu, 15 Feb 2007 17:10:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
Message-Id: <20070215171035.83918aae.akpm@linux-foundation.org>
In-Reply-To: <200702151926.l1FJQT2o020816@pasqua.pmc-sierra.bc.ca>
References: <200702151926.l1FJQT2o020816@pasqua.pmc-sierra.bc.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 13:26:29 -0600
Marc St-Jean <stjeanma@pmc-sierra.com> wrote:

> +			status = *(volatile u32 *)up->port.private_data;

It distresses me that this patch uses a variable which this patch
doesn't initialise anywhere.  It isn't complete.

The sub-driver code whch sets up this field shuld be included in the
patch, no?
