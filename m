Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZBIW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZBIW7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZBIW67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:58:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43505
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZBIW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:58:58 -0500
Date: Mon, 09 Feb 2009 14:58:52 -0800 (PST)
Message-Id: <20090209.145852.156568866.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: jeff@garzik.org, iws@ovro.caltech.edu, jacmet@sunsite.dk,
       dai.haruki@freescale.com, afleming@freescale.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] gianfar: Fix boot hangs while bringing up gianfar
 ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090209193440.GA2537@ami.dom.local>
References: <20090207225555.GA2680@ami.dom.local>
	<20090209172216.GA11312@ovro.caltech.edu>
	<20090209193440.GA2537@ami.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 9 Feb 2009 20:34:40 +0100

> gianfar: Fix boot hangs while bringing up gianfar ethernet
> 
> Ira Snyder found that commit 8c7396aebb68994c0519e438eecdf4d5fa9c7844
> "gianfar: Merge Tx and Rx interrupt for scheduling clean up ring" can
> cause hangs. It's because there was removed clearing of interrupts in
> gfar_schedule_cleanup() (which is called by an interrupt handler) in
> case when netif scheduling has been disabled. This patch brings back
> this action and a comment.
> 
> Reported-by: Ira Snyder <iws@ovro.caltech.edu>
> Reported-by: Peter Korsgaard <jacmet@sunsite.dk>
> Bisected-by: Ira Snyder <iws@ovro.caltech.edu>
> Tested-by: Peter Korsgaard <jacmet@sunsite.dk>
> Tested-by: Ira Snyder <iws@ovro.caltech.edu>
> Signed-by: Jarek Poplawski <jarkao2@gmail.com>

Applied, thanks everyone.
