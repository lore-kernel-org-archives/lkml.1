Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbZLKXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbZLKXRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbZLKXRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:17:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40638
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758471AbZLKXRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:17:16 -0500
Date: Fri, 11 Dec 2009 15:17:22 -0800 (PST)
Message-Id: <20091211.151722.243020071.davem@davemloft.net>
To: lethal@linux-sh.org
Cc: nico@fluxnic.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: smc91x: Fix up type mismatch in smc_drv_resume().
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091211064226.GA7625@linux-sh.org>
References: <20091211064226.GA7625@linux-sh.org>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>
Date: Fri, 11 Dec 2009 15:42:27 +0900

> smc_drv_resume() takes a struct device, while smc_enable_device() takes a
> platform device. This fixes up the smc_enable_device() callsite with the
> proper pointer.
> 
> It's not obvious when this change was introduced, as git history doesn't
> go back that far. Presumably the resume code has always been broken in
> this fashion.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Applied.
