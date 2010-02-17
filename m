Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab0BQEU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 23:20:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50592
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934032Ab0BQEUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 23:20:55 -0500
Date: Tue, 16 Feb 2010 20:21:11 -0800 (PST)
Message-Id: <20100216.202111.104057398.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next 2/2] percpu: add __percpu sparse annotations
 to net drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7B4484.4060909@kernel.org>
References: <4B7B445A.1080108@kernel.org>
	<4B7B4484.4060909@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 17 Feb 2010 10:21:08 +0900

> Add __percpu sparse annotations to net drivers.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David S. Miller <davem@davemloft.net>

Applied.
