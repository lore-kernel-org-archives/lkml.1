Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZJUBv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZJUBv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 21:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZJUBv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 21:51:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32911
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbZJUBvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 21:51:25 -0400
Date: Tue, 20 Oct 2009 18:51:48 -0700 (PDT)
Message-Id: <20091020.185148.193710136.davem@davemloft.net>
To: sfking@fdwdc.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] fix section mismatch in fec.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910201600.10545.sfking@fdwdc.com>
References: <200910201600.10545.sfking@fdwdc.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven King <sfking@fdwdc.com>
Date: Tue, 20 Oct 2009 16:00:10 -0700

> fec_enet_init is called by both fec_probe and fec_resume, so it shouldn't 
> be marked as __init.
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>

Applied, thanks.
