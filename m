Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYLDFMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYLDFMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYLDFLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:11:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYLDFLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:11:52 -0500
Date: Wed, 03 Dec 2008 21:11:52 -0800 (PST)
Message-Id: <20081203.211152.263373582.davem@davemloft.net>
To: npalix@diku.dk
Cc: wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       julia@diku.dk
Subject: Re: [PATCH linux-next] sparc: Add missing of_node_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812021130.06197.npalix@diku.dk>
References: <200812021130.06197.npalix@diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Palix <npalix@diku.dk>
Date: Tue, 2 Dec 2008 11:30:06 +0100

> 
> of_node_put is needed before discarding a value received from
> of_find_node_by_name, eg in error handling code or when the device
> node is no longer used.

Applied to sparc-next-2.6, thanks.

I'm not going to add this to sparc-2.6 or stable, it doesn't
fix any real bugs on sparc (no hot plugged OF nodes, ever)
and adding it to sparc-2.6 would potentitally create some
difficult conflicts in sparc-next-2.6 since we're just finishing
a full merge of arch/sparc64 into arch/sparc there.
